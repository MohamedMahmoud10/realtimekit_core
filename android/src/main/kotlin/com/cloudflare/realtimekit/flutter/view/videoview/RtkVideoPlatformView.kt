package com.cloudflare.realtimekit.flutter.view.videoview

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.DefaultLifecycleObserver
import com.cloudflare.realtimekit.RtkMeetingParticipant
import io.flutter.plugin.platform.PlatformView


class RtkVideoPlatformView(
    private val context: Context,
    val dyteMeetingParticipant: RtkMeetingParticipant,
) : DefaultLifecycleObserver, PlatformView {


    private var videoView: RtkVideoView? = null

    init {
        if (videoView == null) {
            videoView = RtkVideoView(dyteMeetingParticipant, context)
        }
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        val frameLayoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        if (videoView != null) {
            videoView?.layoutParams = frameLayoutParams
        }
    }

    override fun getView(): View? {
        if (videoView == null) {
            videoView = RtkVideoView(dyteMeetingParticipant, context)
        }
        return videoView
    }

    override fun dispose() {
        if (videoView != null){
            videoView?.dispose()
        }
    }

}