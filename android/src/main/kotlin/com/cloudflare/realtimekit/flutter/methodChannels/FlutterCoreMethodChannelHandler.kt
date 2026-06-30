package com.cloudflare.realtimekit.flutter.methodChannels

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.core.content.FileProvider
import androidx.core.net.toUri
import java.io.File
import com.cloudflare.realtimekit.RtkClient
import com.cloudflare.realtimekit.flutter.RtkClientProvider
import com.cloudflare.realtimekit.RtkSink
import com.cloudflare.realtimekit.RtkUtils
import com.cloudflare.realtimekit.listeners.ChatEventListener
import com.cloudflare.realtimekit.listeners.DataUpdateListener
import com.cloudflare.realtimekit.listeners.LivestreamEventListener
import com.cloudflare.realtimekit.listeners.ParticipantEventListener
import com.cloudflare.realtimekit.listeners.ParticipantUpdateEventListener
import com.cloudflare.realtimekit.listeners.PluginEventListener
import com.cloudflare.realtimekit.listeners.PollsEventListener
import com.cloudflare.realtimekit.listeners.RecordingEventListener
import com.cloudflare.realtimekit.listeners.RoomEventListener
import com.cloudflare.realtimekit.listeners.SelfParticipantListener
import com.cloudflare.realtimekit.listeners.StageEventListener
import com.cloudflare.realtimekit.listeners.WaitingRoomEventListener
import com.cloudflare.realtimekit.models.RtkMeetingInfo
import com.cloudflare.realtimekit.participants.RtkRemoteParticipant
import com.cloudflare.realtimekit.platform.RtkUri
import com.cloudflare.realtimekit.flutter.ChatFileDownloader
import com.cloudflare.realtimekit.media.AudioDevice
import com.cloudflare.realtimekit.media.VideoDevice
import com.cloudflare.realtimekit.spotlight.ActiveTabType
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class RtkEvents {
    companion object{
        val onMeetingLeaveCompleted : String = "onMeetingRoomLeaveCompleted"
        val onRemovedFromMeeting : String = "onRemovedFromMeeting"
        val onMeetingEnded: String = "onMeetingEnded"
        val onMeetingInitFailed: String = "onMeetingInitFailed"
        val onMeetingJoinFailed : String = "onMeetingRoomJoinFailed"

        val exitingEvents : HashSet<String> = hashSetOf(onMeetingEnded, onRemovedFromMeeting, onMeetingLeaveCompleted, onMeetingJoinFailed, onMeetingInitFailed)
    }
}

class RtkSinkWrapper(private val sink: EventSink, private val handler: FlutterCoreMethodChannelHandler) : RtkSink {
    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        sink.error(errorCode, errorMessage, errorDetails)
    }

    private fun disposeListeners(){
        handler.disposeListeners()
    }

    override fun success(result: Any?) {
        val eventName: String = ((result as HashMap<*, *>)["name"]) as String
        if(RtkEvents.exitingEvents.contains(eventName)){
            disposeListeners()
            sink.success(result)
        } else{
            sink.success(result)
        }
    }
}

class FlutterCoreMethodChannelHandler(
    private val context: Context,
    private val meetingRoomEventChannel: EventChannel,
    private val chatEventChannel: EventChannel,
    private val participantEventChannel: EventChannel,
    private val selfParticipantChannel: EventChannel,
    private val pollEventChannel: EventChannel,
    private val pluginEventChannel: EventChannel,
    private val dataEventChannel: EventChannel,
    private val recordingEventChannel: EventChannel,
    private val waitingRoomEventChannel: EventChannel,
    private val livestreamEventChannel: EventChannel,
    private val stageEventChannel: EventChannel,
    private val participantUpdateEventChannel: EventChannel
) : MethodChannel.MethodCallHandler {

    /**
     * Always resolves to the *current* native client published by
     * [RtkClientProvider]. Reading dynamically (instead of capturing the client
     * in the constructor) is what lets a rebuilt client — created for each new
     * meeting — be picked up here without recreating this handler. See
     * [RtkClientProvider] for why the client must be rebuilt per meeting.
     */
    private val rtkClient: RtkClient get() = RtkClientProvider.requireRtkClient()

    private var participantEventListener: ParticipantEventListener? = null
    private var meetingRoomEventListener: RoomEventListener? = null
    private var chatEventListener: ChatEventListener? = null
    private var selfEventListener: SelfParticipantListener? = null
    private var pollEventListener: PollsEventListener? = null
    private var pluginEventListener: PluginEventListener? = null
    private var dataEventListener: DataUpdateListener? = null
    private var recordingEventListener: RecordingEventListener? = null
    private var waitingRoomEventListener :  WaitingRoomEventListener? = null
    private var livestreamEventListener: LivestreamEventListener? = null
    private var stageEventListener : StageEventListener? = null
    private var participantUpdateListener: ParticipantUpdateEventListener? = null

    // rtk sinks

    private lateinit var participantSink: EventSink
    private lateinit var meetingRoomSink: EventSink
    private lateinit var chatSink: EventSink
    private lateinit var selfSink: EventSink
    private lateinit var pollSink: EventSink
    private lateinit var pluginSink: EventSink
    private lateinit var dataSink: EventSink
    private lateinit var recordingSink: EventSink
    private lateinit var waitingRoomSink :EventSink
    private lateinit var livestreamSink: EventSink
    private lateinit var stageSink :EventSink

    init {
        setupChatsEventChannel()
        setupMeetingRoomEventChannel()
        setupParticipantEventChannel()
        setupSelfParticipantEventChannel()
        setupPollsEventChannel()
        setupPluginEventChannel()
        setupDataEventChannel()
        setupRecordingEventChannel()
        setupWaitingRoomEventChannel()
        setupLivestreamEventChannel()
        setupStageEventChannel()
        setupParticipantUpdateEventChannel()
    }

    fun disposeListeners(handler: FlutterCoreMethodChannelHandler = this) {
        handler.disposeChatListener()
        handler.disposeMeetingRoomListener()
        handler.disposeParticipantEventListenerListener()
        handler.disposeSelfListener()
        handler.disposePollsListener()
        handler.disposePluginListener()
        handler.disposeDataListener()
        handler.disposeRecordingListener()
        handler.disposeWaitingRoomListener()
        handler.disposeLvsListener()
        handler.disposeStageListener()
    }

    private fun initializeChatListener(){
        val rtkSink = RtkSinkWrapper(chatSink, this)
        chatEventListener = ChatEventListener(rtkSink)
    }

    fun disposeChatListener(){
        if (chatEventListener != null) {
            rtkClient.removeChatListener(chatEventListener!!)
            chatEventListener = null
        }
    }

    private fun setupChatsEventChannel() {
        chatEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    chatSink = events
                    initializeChatListener()
                } else {
                    throw AssertionError("Failed to initialize chats event listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeChatListener()
            }
        })
    }


    private fun initializeMeetingRoomListener(){
        val rtkSink = RtkSinkWrapper(meetingRoomSink, this)
        meetingRoomEventListener = RoomEventListener(rtkSink, rtkClient)
    }

    fun disposeMeetingRoomListener(){
        if (meetingRoomEventListener != null) {
            rtkClient.removeMeetingRoomEventListener(meetingRoomEventListener!!)
            meetingRoomEventListener = null
        }
    }

    private fun setupMeetingRoomEventChannel() {
        meetingRoomEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    meetingRoomSink = events
                    initializeMeetingRoomListener()
                } else {
                    throw AssertionError("Failed to initialize room event listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeMeetingRoomListener()
            }
        })
    }

    private fun initializeParticipantListener(){
        val rtkSink = RtkSinkWrapper(participantSink, this)
        participantEventListener = ParticipantEventListener(rtkSink)
    }

    fun disposeParticipantEventListenerListener(){
        if (participantEventListener != null) {
            rtkClient.removeParticipantsEventListener(participantEventListener!!)
            participantEventListener = null
        }
    }

    private fun setupParticipantEventChannel() {
        participantEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                Log.d("rtkClient", "setupParticipantEventChannel")
                if (events != null) {
                    participantSink = events
                    initializeParticipantListener()
                } else {
                    throw AssertionError("Failed to initialize participant events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeParticipantEventListenerListener()
            }
        })
    }

    private fun initializeSelfListener(){
        val rtkSink = RtkSinkWrapper(selfSink, this)
        selfEventListener = SelfParticipantListener(rtkSink)
    }

    fun disposeSelfListener(){
        if (selfEventListener != null) {
            rtkClient.removeSelfEventListener(selfEventListener!!)
            selfEventListener = null
        }
    }

    private fun setupSelfParticipantEventChannel() {
        selfParticipantChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    selfSink = events
                    initializeSelfListener()
                } else {
                    throw AssertionError("Failed to initialize self participant events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeSelfListener()
            }
        })
    }

    private fun initializePollsListener(){
        val rtkSink = RtkSinkWrapper(pollSink, this)
        pollEventListener = PollsEventListener(rtkSink)
    }

    fun disposePollsListener(){
        if (pollEventListener != null) {
            rtkClient.removePollsEventListener(pollEventListener!!)
            pollEventListener = null
        }

    }

    private fun setupPollsEventChannel() {
        pollEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    pollSink = events
                    initializePollsListener()
                } else {
                    throw AssertionError("Failed to initialize polls events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposePollsListener()
            }
        })
    }

    private fun initializePluginListener(){
        val rtkSink = RtkSinkWrapper(pluginSink, this)
        pluginEventListener = PluginEventListener(rtkSink)
    }

    fun disposePluginListener(){
        if (pluginEventListener != null) {
            rtkClient.removePluginEventListener(pluginEventListener!!)
            pluginEventListener = null
        }
    }

    private fun setupPluginEventChannel() {
        pluginEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    pluginSink = events
                    initializePluginListener()
                } else {
                    throw AssertionError("Failed to initialize plugin events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposePluginListener()
            }
        })
    }

    private fun initializeDataListener(){
        val rtkSink = RtkSinkWrapper(dataSink, this)
        dataEventListener = DataUpdateListener(rtkSink)
    }

    fun disposeDataListener(){
        if (dataEventListener != null) {
            rtkClient.removeDataUpdateListener(dataEventListener!!)
            dataEventListener = null
        }
    }

    private fun setupDataEventChannel() {
        Log.v("rtkClient", "dataEventListener: setup")
        dataEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    dataSink = events
                    initializeDataListener()
                    Log.v("rtkClient", "dataEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize data events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeDataListener()
            }
        })
    }

    private fun initializeRecordingListener(){
        val rtkSink = RtkSinkWrapper(recordingSink, this)
        recordingEventListener = RecordingEventListener(rtkSink)
    }

    fun disposeRecordingListener(){
        if (recordingEventListener != null) {
            rtkClient.removeRecordingEventListener(recordingEventListener!!)
            recordingEventListener = null
        }
    }

    private fun setupRecordingEventChannel(){
        Log.v("rtkClient", "recordingEventListener: setup")
        recordingEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    recordingSink = events
                    initializeRecordingListener()
                    Log.v("rtkClient", "recordingEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize recording events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeRecordingListener()
            }
        })
    }

    private fun initializeWaitingRoomListener(){
        val rtkSink = RtkSinkWrapper(waitingRoomSink, this)
        waitingRoomEventListener = WaitingRoomEventListener(rtkSink)
    }

    fun disposeWaitingRoomListener(){
        if (waitingRoomEventListener != null) {
            rtkClient.removeWaitlistEventListener(waitingRoomEventListener!!)
            waitingRoomEventListener = null
        }
    }

    private fun setupWaitingRoomEventChannel(){
        Log.v("rtkClient", "waitingRoomEventListener: setup")
        waitingRoomEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    waitingRoomSink = events
                    initializeWaitingRoomListener()
                    Log.v("rtkClient", "waitingRoomEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize waiting room events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeWaitingRoomListener()
            }
        })
    }

    private fun initializeLvsListener () {
        val rtkSink = RtkSinkWrapper(livestreamSink, this)
        livestreamEventListener = LivestreamEventListener(rtkSink)
    }

    fun disposeLvsListener(){
        if (livestreamEventListener != null) {
            rtkClient.removelivestreamEventListener(livestreamEventListener!!)
            livestreamEventListener = null
        }
    }

    private fun setupLivestreamEventChannel(){
        Log.v("rtkClient", "livestreamEventListener: setup")
        livestreamEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                if (events != null) {
                    livestreamSink = events
                    initializeLvsListener()
                    Log.v("rtkClient", "livestreamEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize livestream events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeLvsListener()
            }
        })
    }

    private fun initializeStageListener () {
        val rtkSink = RtkSinkWrapper(stageSink, this)
        stageEventListener = StageEventListener(rtkSink)
    }

    fun disposeStageListener(){
        if(stageEventListener !=null){
            rtkClient.removeStageEventListener(stageEventListener!!)
            stageEventListener = null
        }
    }

    private fun setupStageEventChannel() {
        Log.v("rtkClient", "stageEventListener: setup")
        stageEventChannel.setStreamHandler(object : EventChannel.StreamHandler{
            override fun onListen(arguments: Any?, events: EventSink?) {
                if(events != null) {
                    stageSink = events
                    initializeStageListener()
                    Log.v("rtkClient", "stageEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize stage events listener")
                }
            }

            override fun onCancel(arguments: Any?) {
                disposeStageListener()
            }
        })
    }

    private fun initializeParticipantUpdateChannel(events: EventSink){
        val eventSink = RtkSinkWrapper(events, this)
        participantUpdateListener = ParticipantUpdateEventListener(eventSink)

    }

    private fun setupParticipantUpdateEventChannel(){
        Log.v("rtkClient", "participantUpdateEventListener: setup")
        participantUpdateEventChannel.setStreamHandler(object: EventChannel.StreamHandler{
            override fun onListen(arguments: Any?, events: EventSink?) {
                if(events != null) {
                    initializeParticipantUpdateChannel(events)
                    Log.v("rtkClient", "participantUpdateEventListener: added")
                } else {
                    throw AssertionError("Failed to initialize participant update events listener")
                }
            }

            override fun onCancel(arguments: Any?) {

            }
        })
    }

    private fun resolveContentUri(filePath: String): Uri {
        if (filePath.startsWith("content://")) {
            return Uri.parse(filePath)
        }
        val file = if (filePath.startsWith("file://")) {
            File(Uri.parse(filePath).path!!)
        }
        else {
            File(filePath)
        }
        return FileProvider.getUriForFile(
            context,
            context.packageName + ".rtkfileprovider",
            file
        )
    }

override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                val meetingInfo = RtkMeetingInfo.fromMap(call.arguments as Map<String, Any?>)
                rtkClient.init(meetingInfo, onSuccess = {
                    result.success(null)
                }) {
                    error -> {
                    result.error(error!!.code.toString(),error.message, null)
                }}
                return
            }
            "meta" -> {
                return result.success(rtkClient.getMetaData())
            }

            "enableCache" -> {
                rtkClient.enableCache()
                return result.success(null)
            }

            "disableCache" -> {
                rtkClient.disableCache()
                return result.success(null)
            }
            
            "joinRoom" -> {
                rtkClient.joinRoom(onSuccess = {
                    result.success(null)
                }){
                    error -> {
                        result.error(error!!.code.toString(),error.message, null)
                }
                }
                return
            }

            "addParticipantUpdateListener" -> {
                val participantId = call.arguments as String
                val participants = rtkClient.participants()
                try{
                    val allParticipants = mutableListOf<RtkRemoteParticipant>()
                    allParticipants.addAll(participants.waitlisted)
                    allParticipants.addAll(participants.joined)
                    allParticipants.addAll(participants.screenShares)
                    val participant = allParticipants.first { it.id==participantId }
                    participant.addParticipantUpdateListener(participantUpdateListener!!)
                } catch (e: NoSuchElementException){
                    result.error(e.cause.toString(), e.message, e.stackTrace)
                }
            }

            "removeParticipantUpdateListener" -> {
                val participantId = call.arguments as String
                val participants = rtkClient.participants()
                try{
                    val allParticipants = mutableListOf<RtkRemoteParticipant>()
                    allParticipants.addAll(participants.waitlisted)
                    allParticipants.addAll(participants.joined)
                    allParticipants.addAll(participants.screenShares)
                    val participant = allParticipants.first { it.id==participantId }
                    participant.removeParticipantUpdateListener(participantUpdateListener!!)
                } catch (e: NoSuchElementException){
                    result.error(e.cause.toString(), e.message, e.stackTrace)
                }
            }

            "removeParticipantUpdateListeners" ->{
                val participantId = call.arguments as String
                val participants = rtkClient.participants()
                try{
                    val allParticipants = mutableListOf<RtkRemoteParticipant>()
                    allParticipants.addAll(participants.waitlisted)
                    allParticipants.addAll(participants.joined)
                    allParticipants.addAll(participants.screenShares)
                    val participant = allParticipants.first { it.id==participantId }
                    participant.removeParticipantUpdateListeners()
                } catch (e: NoSuchElementException){
                    result.error(e.cause.toString(), e.message, e.stackTrace)
                }
            }

            "leaveRoom" -> {
                rtkClient.leaveRoom(onSuccess = {
                    result.success(null)
                }){
                    error -> {
                        result.error(error!!.code.toString(),error.message, null)
                }
                }
                return
            }

            "addMeetingRoomEventListener" -> {
                if(meetingRoomEventListener==null){
                    initializeMeetingRoomListener()
                }
                if (meetingRoomEventListener != null) {
                    rtkClient.addMeetingRoomEventListener(meetingRoomEventListener!!)
                    Log.v("rtkClient", "added meeting room event listener")
                    return result.success(null)
                }
                return result.error("", "Failed attaching room event listener", "")

            }

            "removeMeetingRoomEventListener" -> {
                if (meetingRoomEventListener != null) {
                    rtkClient.removeMeetingRoomEventListener(meetingRoomEventListener!!)
                    meetingRoomEventListener = null
                }
                return result.success(null)
            }

            "addChatListener" -> {
                if(chatEventListener==null){
                    initializeChatListener()
                }
                if (chatEventListener != null) {
                    rtkClient.addChatListener(chatEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching chat event listener", "")

            }

            "removeChatListener" -> {
                if (chatEventListener != null) {
                    rtkClient.removeChatListener(chatEventListener!!)
                    chatEventListener = null
                }
                return result.success(null)
            }
            "addParticipantsEventListener" -> {
                if(participantEventListener==null){
                    initializeParticipantListener()
                }
                if (participantEventListener != null) {
                    rtkClient.addParticipantsEventListener(participantEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching participant event listener", "")

            }

            "addSelfParticipantEventListener" -> {
                if(selfEventListener==null){
                    initializeSelfListener()
                }
                if (selfEventListener != null) {
                    rtkClient.addSelfEventListener(selfEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching self events listener", "")
            }

            "removeParticipantEventListener" -> {
                if (participantEventListener != null) {
                    rtkClient.removeParticipantsEventListener(participantEventListener!!)
                    participantEventListener = null
                }
                return result.success(null)
            }

            "addPluginEventListener" -> {
                if(pluginEventListener==null){
                    initializePluginListener()
                }
                if (pluginEventListener != null) {
                    rtkClient.addPluginEventListener(pluginEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching plugin event listener", "")
            }
            "removePluginEventListener" -> {
                if (pluginEventListener != null) {
                    rtkClient.removePluginEventListener(pluginEventListener!!)
                    pluginEventListener = null
                }
                return result.success(null)
            }

            "addPollsEventListener" -> {
                if(pollEventListener==null){
                    initializePollsListener()
                }
                if (pollEventListener != null) {
                    rtkClient.addPollsEventListener(pollEventListener!!)
                    return result.success(null)
                }

                return result.error("", "Failed attaching polls event listener", "")

            }

            "removePollsEventListener" -> {
                if (pollEventListener != null) {
                    rtkClient.removePollsEventListener(pollEventListener!!)
                    pollEventListener = null
                }
                return result.success(null)
            }

            "addDataUpdateListener" -> {
                Log.v("rtkClient", "dataEventListener: addDataUpdateListener")
                if(dataEventListener==null){
                    initializeDataListener()
                }
                if (dataEventListener != null) {
                    rtkClient.addDataUpdateListener(dataEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching data update listener", "")

            }

            "removeDataUpdateListener" -> {
                if (dataEventListener != null) {
                    rtkClient.removeDataUpdateListener(dataEventListener!!)
                    dataEventListener = null
                }
                return result.success(null)
            }

            "addRecordingEventListener" ->{
                if(recordingEventListener==null){
                    initializeRecordingListener()
                }
                if(recordingEventListener !=null){
                    rtkClient.addRecordingEventListener(recordingEventListener!!);
                    return result.success(null)
                }
                return result.error("", "Failed attaching recording listener", "")
            }

            "removeRecordingEventListener" -> {
                if(recordingEventListener !=null){
                    rtkClient.removeRecordingEventListener(recordingEventListener!!);
                    recordingEventListener = null
                }
                return result.success(null)
            }


            "addWaitingRoomEventListener" -> {
                Log.v("rtkClient", "dataEventListener: addWaitingRoomListener")
                if(waitingRoomEventListener==null){
                    initializeWaitingRoomListener()
                }
                if (waitingRoomEventListener != null) {
                    rtkClient.addWaitlistEventListener(waitingRoomEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching waiting room listener", "")

            }

            "removeWaitingRoomEventListener" -> {
                if (dataEventListener != null) {
                    rtkClient.removeWaitlistEventListener(waitingRoomEventListener!!)
                    waitingRoomEventListener = null
                }
                return result.success(null)
            }

            "addLivestreamEventListener" -> {
                if(livestreamEventListener==null){
                    initializeLvsListener()
                }
                if(livestreamEventListener != null){
                    rtkClient.addlivestreamEventListener(livestreamEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching livestream listeners", "")
            }

            "removeLivestreamEventListener" -> {
                if(livestreamEventListener != null){
                    rtkClient.removelivestreamEventListener(livestreamEventListener!!)
                    livestreamEventListener = null
                }
                return result.success(null)
            }

            "addStageEventListener" -> {
                Log.v("rtkClient", "dataEventListener: addStageEventListener")
                if(stageEventListener==null){
                    initializeStageListener()
                }
                if (stageEventListener != null) {
                    rtkClient.addStageEventListener(stageEventListener!!)
                    return result.success(null)
                }
                return result.error("", "Failed attaching stage listener", "")
            }

            "removeStageEventListener" -> {
                if(stageEventListener!= null){
                    rtkClient.removeStageEventListener(stageEventListener!!)
                    stageEventListener = null
                }
                return result.success(null)
            }

            "participants" -> {
                result.success(rtkClient.participants().toMap())
            }

            "enableVideo" -> {
                return rtkClient.enableVideo {
                    value -> {
                        if (value == null) {
                            result.success(null)
                        } else {
                            result.error(value.code.toString(), value.message, null)
                        }
                }
                }
            }

            "disableVideo" -> {
                return rtkClient.disableVideo{
                    value -> {
                        if (value == null) {
                            result.success(null)
                        } else {
                            result.error(value.code.toString(), value.message, null)
                        }
                    }
                }
            }

            "enableAudio" -> {
                return rtkClient.enableAudio{
                    value -> {
                        if (value == null) {
                            result.success(null)
                        } else {
                            result.error(value.code.toString(), value.message, null)
                        }
                }
                }
            }

            "disableAudio" -> {
                return rtkClient.disableAudio {
                    value -> {
                        if (value == null) {
                            result.success(null)
                        } else {
                            result.error(value.code.toString(), value.message, null)
                        }
                }
                }
            }

            "sendTextMessage" -> {
                rtkClient.sendTextMessage(call.arguments as String)
                result.success(null)
            }

            "sendFileMessage" -> {
                val messageInfo = call.arguments as Map<String, Any?>
                val filePath = messageInfo["path"] as String
                val uri: Uri = resolveContentUri(filePath)
                val rtkUri = RtkUri(uri)
                return rtkClient.sendFileMessage(rtkUri) { error ->
                    result.success(error?.code)
                }
            }

            "sendImageMessage" -> {
                val messageInfo = call.arguments as Map<String, Any?>
                val filePath = messageInfo["path"] as String
                val uri: Uri = resolveContentUri(filePath)
                val rtkUri = RtkUri(uri)
                return rtkClient.sendImageMessage(rtkUri) { error ->
                    result.success(error?.code)
                }
            }

            "downloadAttachment" -> {
                val attachment = call.arguments as Map<String, Any?>
                val url = attachment["url"] as String
                val fileName = attachment["fileName"] as String
               ChatFileDownloader.enqueue(context, url, fileName)
                result.success(null)
            }

            "setDisplayName" -> {
                val displayName = call.arguments as String
                rtkClient.setDisplayName(displayName)
                result.success(null)
            }

            "getAudioDevices" -> {
                val audioDevice = rtkClient.getAudioDevices()
                result.success(audioDevice.map { it.toMap() })
            }

            "getVideoDevices" -> {
                val videoDevice = rtkClient.getVideoDevices()
                result.success(videoDevice.map { it.toMap() })
            }

            "setAudioDevice" -> {
                val rtkAudioDeviceMap = call.arguments as Map<String, Any>
                val audioDevice = AudioDevice.fromMap(rtkAudioDeviceMap)
                rtkClient.setAudioDevice(audioDevice)
            }

            "setVideoDevice" -> {
                val rtkVideoDeviceMap = call.arguments as Map<String, Any>
                val videoDevice = VideoDevice.fromMap(rtkVideoDeviceMap)
                rtkClient.setVideoDevice(videoDevice)
            }

            "getSelectedVideoDevice" -> {
                val selectedVideoDevice = rtkClient.getSelectedVideoDevice()
                result.success(selectedVideoDevice?.toMap())
            }

            "getSelectedAudioDevice" -> {
                val selectedAudioDevice = rtkClient.getSelectedAudioDevice()
                result.success(selectedAudioDevice?.toMap())
            }

            "switchCamera" -> {
                rtkClient.switchCamera()
                result.success(null)
            }

            "createPoll" -> {
                val pollChars = call.arguments as Map<String, Any>
                rtkClient.createPoll(pollChars)
                result.success(null)
            }

            "votePoll" -> {
                val pollVote = call.arguments as Map<String, Any>
                rtkClient.voteOnPoll(pollVote)
                result.success(null)
            }

            "startRecording" -> {
                return rtkClient.startRecording{
                    error -> result.success(error?.code)
                }
            }

            "stopRecording" -> {
                return rtkClient.stopRecording{
                    error -> result.success(error?.code)
                }
            }

            "getRecordingState" -> {
                val state = rtkClient.getRecordingState()
                val recordingState = state.toMap()["state"]
                result.success(recordingState)
            }

            "setPage" -> {
                val pageNumber = call.arguments as Int
                rtkClient.setPage(pageNumber)
                result.success(null)
            }


            "getActivePlugins" -> {
                val activePlugins: List<Map<String, Any>> = rtkClient.getActivePlugins()
                result.success(activePlugins)
            }

            "activatePlugin" -> {
                val pluginId = call.arguments as String
                rtkClient.activatePlugin(pluginId)
                result.success(null)
            }

            "deactivatePlugin" -> {
                val pluginId = call.arguments as String
                rtkClient.deactivatePlugin(pluginId)
                result.success(null)
            }

            "pinParticipant" -> {
                val participantId = call.arguments as String
                rtkClient.pinParticipant(participantId)
                result.success(null)
            }

            "unpinParticipant" -> {
                rtkClient.unpinParticipant()
                result.success(null)
            }

            "disableParticipantAudio" -> {
                val participantId = call.arguments as String
                when (val error = rtkClient.disableParticipantAudio(participantId)) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }
            }

            "disableAllAudio" -> {
                when (val error = rtkClient.disableAllAudio()) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }
            }

            "disableParticipantVideo" -> {
                val participantId = call.arguments as String
                when (val error = rtkClient.disableParticipantVideo(participantId)) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }

            }

            "disableAllVideo" -> {
                when (val error = rtkClient.disableAllVideo()) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }
            }

            "kickParticipant" -> {
                val participantId = call.arguments as String
                when (val error = rtkClient.kickParticipant(participantId)) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }
            }

            "kickAll" -> {
                when (val error = rtkClient.kickAll()) {
                    null -> result.success(null)
                    else -> result.error(error.code.toString(), error.message, null)
                }
            }

            "acceptWaitListedRequest" -> {
                val participantId = call.arguments as String
                rtkClient.acceptWaitingRoomRequest(participantId)
            }

            "acceptAllWaitingRoomRequests" -> {
                rtkClient.acceptAllWaitingRoomRequests()
            }

            "rejectWaitListedRequest" -> {
                val participantId = call.arguments as String
                rtkClient.rejectWaitingRoomRequest(participantId)
            }

            // Stage Controls
            "requestStageAccess" -> {
                rtkClient.requestToJoinStage()
                return result.success(null)
            }

            "cancelRequestAccess" -> {
                // TODO: change this to cancel request
                rtkClient.withdrawJoinStageRequest()
                return result.success(null)
            }

            "grantAccessToStage" -> {
                val participantIds = call.arguments as List<String>
                if(participantIds.isNotEmpty()) {
                    rtkClient.grantAccessToStage(participantIds)
                } else{
                    result.error("", "Error: Participant ID is null", "")
                }

                return result.success(null)
            }

            "denyAccessToStage" -> {
                val participantIds = call.arguments as List<String>
                if(participantIds.isNotEmpty()) {
                    rtkClient.denyAccessToStage(participantIds)
                } else {
                    result.error("", "Error: Participant ID is null", "")
                }

            }


            "joinStage" -> {
                rtkClient.joinStage()
                return result.success(null)
            }

            "leaveStage" -> {
                rtkClient.leaveStage()
                return result.success(null)
            }

            "kickPeerFromStage" -> {
//                val participantIdTokenizer = StringTokenizer(call.arguments as String, ",")
//                val participantIds = mutableListOf<String>(
//                    participantIdTokenizer.nextToken()
//                )
//                while (participantIdTokenizer.hasMoreTokens()) {
//                    participantIds.add(participantIdTokenizer.nextToken())
//                }
                val participantIds = call.arguments as List<String>
                if(participantIds.isNotEmpty()) {
                    rtkClient.kickPeerFromStage(participantIds)
                } else {
                    result.error("", "Error: Participant ID is null", "")
                }
                return result.success(null)
            }

            // Livestream Controls
            "goLive" -> {
                this@FlutterCoreMethodChannelHandler.rtkClient.startLvs()
                return result.success(null)
            }

            "stopLive" -> {
                rtkClient.stopLvs()
                return result.success(null)
            }

            "getLivestreamState" -> {
                val streamState = rtkClient.getStreamState()
                return result.success(streamState)
            }

            "getLivestreamUrl" -> {
                val streamUrl = rtkClient.getStreamUrl()
                return result.success(streamUrl)
            }

            "getLivestreamRoomName" -> {
//                val streamRoomName = rtkClient.getStreamRoomName()
//                return result.success(streamRoomName)
            }

            "launchUrl" -> {
                val url = call.arguments as String
                val canLaunch  = RtkUtils().launchUrl(context, url)
                return result.success(canLaunch)
            }

            "enableScreenshare" -> {
                rtkClient.enableScreenShare()
                return result.success(null)
            }

            "disableScreenshare" -> {
                rtkClient.disableScreenShare()
                return result.success(null)
            }

            "broadcastMessage" -> {
                val args = call.arguments as Map<String, Any>
                val type: String = args["type"] as String
                val payload = args["payload"] as Map<String, Any>
                rtkClient.broadcastMessage(type, payload)
                return result.success(null)
            }

            "release" -> {
                rtkClient.releaseMeeting(onReleaseSuccess = { disposeListeners(); result.success(true)}, onReleaseFailed = {result.success(false)})
                return
            }

            "getSelfActiveTab" -> {
                return result.success(rtkClient.getSelfActiveTab())
            }

            "syncTab" -> {
                val args = call.arguments as Map<String, Any>
                val id: String = args["id"] as String
                val tabType  = ActiveTabType.valueOf(args["type"] as String)
                rtkClient.tabSync(id, tabType)
                return result.success(null)
            }

            "logSdkVersion" -> {
                val args = call.arguments as Map<String, String>
                val sdkName = args["sdkName"] as String
                val version = args["version"] as String
                rtkClient.setUiKitInfo(sdkName, version)
                return result.success(null)
            }
        }
    }
}