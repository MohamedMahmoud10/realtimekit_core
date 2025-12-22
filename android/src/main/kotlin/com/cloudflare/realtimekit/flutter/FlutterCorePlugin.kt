package com.cloudflare.realtimekit.flutter

import android.app.Activity
import android.os.PowerManager
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
        if (flutterCoreMethodChannelHandler == null) {
            flutterCoreMethodChannelHandler = FlutterCoreMethodChannelHandler(
                rtkClientAndroid!!,
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
        channel.setMethodCallHandler(flutterCoreMethodChannelHandler)
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
        if (flutterCoreMethodChannelHandler == null) {
            flutterCoreMethodChannelHandler = FlutterCoreMethodChannelHandler(
                rtkClientAndroid!!,
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
        channel.setMethodCallHandler(flutterCoreMethodChannelHandler)
    }

    override fun onDetachedFromActivity() {
        setWakelock(false)
        activity = null
        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
            rtkClientAndroid = null
        }
        channel.setMethodCallHandler(null)
    }

    override fun onPreEngineRestart() {
        if (rtkClientAndroid != null && rtkClientAndroid!!.isRoomJoined) {
            rtkClientAndroid?.leaveRoom(onSuccess = {}){}
        }
        rtkClientAndroid = null
        flutterCoreMethodChannelHandler = null
    }

    override fun onEngineWillDestroy() {
    }
}
