package com.cloudflare.realtimekit.flutter

import android.app.Activity
import android.os.PowerManager
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import com.cloudflare.realtimekit.RealtimeKitClient
import com.cloudflare.realtimekit.RealtimeKitMeetingBuilder
import com.cloudflare.realtimekit.RtkClient
import com.cloudflare.realtimekit.flutter.methodChannels.FlutterCoreMethodChannelHandler
import com.cloudflare.realtimekit.flutter.view.livestream.RtkLivestreamViewFactory
import com.cloudflare.realtimekit.flutter.view.plugin.RtkPluginViewFactory
import com.cloudflare.realtimekit.flutter.view.screenshare.RtkScreenshareViewFactory
import com.cloudflare.realtimekit.flutter.view.videoview.RtkVideoViewFactory
import com.cloudflare.realtimekit.flutter.view.videoview.VideoViewController
import io.flutter.embedding.engine.FlutterEngine.EngineLifecycleListener
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterCorePlugin : FlutterPlugin, ActivityAware, EngineLifecycleListener {
    private lateinit var channel: MethodChannel
    private lateinit var videoViewChannel: MethodChannel
    private lateinit var realtimeClient: RealtimeKitClient
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private var rtkClientAndroid: RtkClient? = null
    private var flutterCoreMethodChannelHandler: MethodChannel.MethodCallHandler? = null
    private var videoViewController: MethodChannel.MethodCallHandler? = null

    private lateinit var meetingRoomEventChannel: EventChannel
    private lateinit var chatEventChannel: EventChannel
    private lateinit var participantEventChannel: EventChannel
    private lateinit var selfParticipantEventChannel: EventChannel
    private lateinit var pollsEventChannel: EventChannel
    private lateinit var pluginEventChannel: EventChannel
    private lateinit var dataEventChannel: EventChannel
    private lateinit var recordingEventChannel: EventChannel
    private lateinit var waitingRoomEventChannel: EventChannel
    private lateinit var livestreamEventChannel: EventChannel
    private lateinit var stageEventChannel: EventChannel
    private lateinit var participantUpdateEventChannel: EventChannel

    private var activity: Activity? = null

    /**
     * Whether the current native meeting client has already been used for a
     * meeting (i.e. `init` was called on it). The client built at activity-attach
     * is fresh, so it is reused as-is; once used it can never be re-`init()`'d, so
     * we rebuild a fresh one when the meeting is released (see [rebuildMeetingClient]).
     */
    private var meetingClientUsed = false

    /** Publishes the current native client so the handler and view factories
     *  (which read dynamically) operate on the live instance. */
    private fun publishClient() {
        RtkClientProvider.rtkClient = rtkClientAndroid
        RtkClientProvider.realtimeClient = realtimeClient
    }

    /**
     * Builds a brand-new native meeting client so the *next* meeting starts on a
     * clean instance. Called on `release` (i.e. when leaving a meeting), because
     * the Cloudflare RealtimeKit SDK cannot re-`init()` a client once it has been
     * used — a second `init()` never completes and the Flutter UI hangs forever
     * on the loading spinner.
     *
     * Rebuilding here (on leave) rather than on the next `init` is deliberate: the
     * next meeting re-attaches its event listeners *before* it calls `init`, so the
     * fresh client must already be published by then, otherwise those listeners
     * would bind to the old (discarded) client and the rejoin would still hang.
     */
    private fun rebuildMeetingClient() {
        val currentActivity = activity ?: return
        try {
            rtkClientAndroid?.let { old ->
                if (old.isRoomJoined) old.leaveRoom(onSuccess = {}) {}
            }
        } catch (e: Exception) {
            Log.w("FlutterCorePlugin", "rebuildMeetingClient: leaving old room failed: ${e.message}")
        }
        realtimeClient = RealtimeKitMeetingBuilder.build(currentActivity)
        rtkClientAndroid = RtkClient(realtimeClient)
        publishClient()
    }

    /**
     * Wraps the real method-call handler. Tracks when the client becomes "used"
     * (on `init`) and, on `release`, rebuilds a fresh native client once the SDK
     * finishes releasing the old one — so join -> leave -> join again works
     * without an app restart. Everything else is delegated unchanged to the
     * handler, which reads the live client from [RtkClientProvider].
     */
    private val methodCallInterceptor = object : MethodChannel.MethodCallHandler {
        override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                "init" -> {
                    meetingClientUsed = true
                    flutterCoreMethodChannelHandler?.onMethodCall(call, result)
                        ?: result.notImplemented()
                }
                "release" -> {
                    val wrapped = object : MethodChannel.Result {
                        override fun success(res: Any?) {
                            if (meetingClientUsed) {
                                rebuildMeetingClient()
                                meetingClientUsed = false
                            }
                            result.success(res)
                        }

                        override fun error(code: String, message: String?, details: Any?) {
                            result.error(code, message, details)
                        }

                        override fun notImplemented() {
                            result.notImplemented()
                        }
                    }
                    flutterCoreMethodChannelHandler?.onMethodCall(call, wrapped)
                        ?: result.notImplemented()
                }
                else -> flutterCoreMethodChannelHandler?.onMethodCall(call, result)
                    ?: result.notImplemented()
            }
        }
    }

    private fun setWakelock(enabled: Boolean) {
        activity?.runOnUiThread {
            val window = activity?.window
            if (window != null) {
                if (enabled) {
                    // Add the FLAG_KEEP_SCREEN_ON flag
                    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                } else {
                    // Clear the FLAG_KEEP_SCREEN_ON flag
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
            }
        }
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        FlutterEngineCache.getInstance().put("DyteFlutterEngine", flutterPluginBinding.flutterEngine)
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "realtimekit_core_android")
        videoViewChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "realtimekit_core/video_view#refreshVideo")
        flutterPluginBinding.flutterEngine.addEngineLifecycleListener(this)

        meetingRoomEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, meetingRoomEventChannelName)
        chatEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, chatsEventChannelName)
        participantEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, participantEventChannelName)
        selfParticipantEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, selfParticipantEventChannelName)
        pollsEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, pollsEventChannelName)
        pluginEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, pluginEventsChannelName)
        dataEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, dataEventsChannelName)
        recordingEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, recodingEventsChannelName)
        waitingRoomEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, waitingRoomEventsChannelName)
        livestreamEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, livestreamEventsChannelName)
        stageEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, stageEventsChannelName)
        participantUpdateEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, participantUpdateEventChannelName)
        videoViewChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "realtimekit_core/video_view#refreshVideo")
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
            rtkClientAndroid = null
        }
        channel.setMethodCallHandler(null)

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        realtimeClient = RealtimeKitMeetingBuilder.build(binding.activity)
        activity = binding.activity
        setWakelock(true)
        rtkClientAndroid = RtkClient(realtimeClient)
        publishClient()
        if (flutterCoreMethodChannelHandler == null) {
            flutterCoreMethodChannelHandler = FlutterCoreMethodChannelHandler(
                flutterPluginBinding.applicationContext,
                meetingRoomEventChannel = meetingRoomEventChannel,
                chatEventChannel = chatEventChannel,
                participantEventChannel = participantEventChannel,
                selfParticipantChannel = selfParticipantEventChannel,
                pollEventChannel = pollsEventChannel,
                pluginEventChannel = pluginEventChannel,
                dataEventChannel = dataEventChannel,
                recordingEventChannel = recordingEventChannel,
                waitingRoomEventChannel = waitingRoomEventChannel,
                livestreamEventChannel = livestreamEventChannel,
                stageEventChannel = stageEventChannel,
                participantUpdateEventChannel= participantUpdateEventChannel
            )
        }
        if (videoViewController == null){
            videoViewController = VideoViewController()
        }
        videoViewChannel.setMethodCallHandler(videoViewController)
        channel.setMethodCallHandler(methodCallInterceptor)
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "DytePlatformVideoView",
            RtkVideoViewFactory(
                realtimeClient,
            )
        )
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "DytePlatformScreenshareView",
            RtkScreenshareViewFactory(realtimeClient)
        )
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "DytePlatformPluginView",
            RtkPluginViewFactory(realtimeClient)
        )
        flutterPluginBinding.platformViewRegistry.registerViewFactory("DytePlatformLivestreamView", RtkLivestreamViewFactory())
    }


    override fun onDetachedFromActivityForConfigChanges() {
        setWakelock(false)
        activity = null
        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
        }
        channel.setMethodCallHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        setWakelock(true)
        realtimeClient = RealtimeKitMeetingBuilder.build(binding.activity)
        rtkClientAndroid = RtkClient(realtimeClient)
        publishClient()
        // Freshly built client on reattach — let the next init reuse it as-is.
        meetingClientUsed = false
        if (flutterCoreMethodChannelHandler == null) {
            flutterCoreMethodChannelHandler = FlutterCoreMethodChannelHandler(
                flutterPluginBinding.applicationContext,
                meetingRoomEventChannel = meetingRoomEventChannel,
                chatEventChannel = chatEventChannel,
                participantEventChannel = participantEventChannel,
                selfParticipantChannel = selfParticipantEventChannel,
                pollEventChannel = pollsEventChannel,
                pluginEventChannel = pluginEventChannel,
                dataEventChannel = dataEventChannel,
                recordingEventChannel = recordingEventChannel,
                waitingRoomEventChannel = waitingRoomEventChannel,
                livestreamEventChannel = livestreamEventChannel,
                stageEventChannel = stageEventChannel,
                participantUpdateEventChannel = participantUpdateEventChannel
            )
        }
        channel.setMethodCallHandler(methodCallInterceptor)
    }

    override fun onDetachedFromActivity() {
        setWakelock(false)
        activity = null
        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
            rtkClientAndroid = null
        }
        meetingClientUsed = false
        RtkClientProvider.rtkClient = null
        RtkClientProvider.realtimeClient = null
        channel.setMethodCallHandler(null)
    }

    override fun onPreEngineRestart() {
        // Hot restart / engine restart: the Dart isolate restarts and runs a new
        // meeting from scratch, but onAttachedToActivity is NOT called again. Leave
        // any active room and rebuild a fresh native client (the activity is still
        // attached) while KEEPING the method-call handler + channel interceptor
        // wired, so the restarted Dart side has a live client to talk to. Nulling
        // the handler/holder instead (as before) makes the next init() hit a null
        // handler, which surfaces as a concurrent-modification crash and a stuck
        // loading screen.
        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
        }
        val currentActivity = activity
        if (currentActivity != null) {
            realtimeClient = RealtimeKitMeetingBuilder.build(currentActivity)
            rtkClientAndroid = RtkClient(realtimeClient)
            publishClient()
            meetingClientUsed = false
        } else {
            rtkClientAndroid = null
            meetingClientUsed = false
            RtkClientProvider.rtkClient = null
            RtkClientProvider.realtimeClient = null
        }
    }

    override fun onEngineWillDestroy() {
    }
}
