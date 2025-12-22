package com.cloudflare.realtimekit.flutter.view.videoview

import android.content.Context
import android.view.ViewGroup
import android.widget.FrameLayout
import com.cloudflare.realtimekit.RtkMeetingParticipant
import com.cloudflare.realtimekit.participants.RtkParticipantUpdateListener
import com.cloudflare.realtimekit.self.RtkSelfParticipant
import io.dyte.flutter.R

class RtkSelfVideoView(
    private val dyteParticipant: RtkSelfParticipant,
    context: Context,
) : FrameLayout(context) {

    private var mDyteVideoViewContainer: FrameLayout

    init {
        inflate(context, R.layout.video_view, this)
        mDyteVideoViewContainer = findViewById(R.id.dyte_video_view)
        refreshVideo(dyteParticipant)
        attachListenerToVideoView()
    }


    private fun attachListenerToVideoView() {
        dyteParticipant.addParticipantUpdateListener(object : RtkParticipantUpdateListener {
            override fun onVideoUpdate(
                participant: RtkMeetingParticipant,
                isEnabled: Boolean
            ) {
                super.onVideoUpdate(participant, isEnabled)
                refreshVideo(dyteParticipant)
            }
        })
    }

    private fun refreshVideo(dyteParticipant: RtkSelfParticipant) {
        val videoView = dyteParticipant.getVideoView()
        mDyteVideoViewContainer.removeAllViews()
        (videoView?.parent as? ViewGroup)?.removeView(videoView)
        videoView?.let {
            mDyteVideoViewContainer.addView(it)
            it.renderVideo()
        }
    }

}