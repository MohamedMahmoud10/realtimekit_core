package com.cloudflare.realtimekit.flutter.view.videoview

import android.content.Context
import android.view.ViewGroup
import android.widget.FrameLayout
import com.cloudflare.realtimekit.RtkMeetingParticipant
import io.dyte.flutter.R

class RtkVideoView(
    private val dyteParticipant: RtkMeetingParticipant,
    context: Context,
) : FrameLayout(context) {

    private var mDyteVideoViewContainer: FrameLayout

    init {
        inflate(context, R.layout.video_view, this)
        mDyteVideoViewContainer = findViewById(R.id.dyte_video_view)
        refreshVideo()
    }

    fun refreshVideo() {
        val videoView = dyteParticipant.getVideoView()
        mDyteVideoViewContainer.removeAllViews()
        (videoView?.parent as? ViewGroup)?.removeView(videoView)
        videoView?.let {
            mDyteVideoViewContainer.addView(it)
            it.renderVideo()
        }
    }

    fun dispose(){
        // dyteParticipant.getVideoView()?.release()
    }

}