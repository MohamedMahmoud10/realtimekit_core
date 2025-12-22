package com.cloudflare.realtimekit.flutter.view.screenshare
import RtkScreenShareView
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.DefaultLifecycleObserver
import com.cloudflare.realtimekit.RtkMeetingParticipant
import io.flutter.plugin.platform.PlatformView

class RtkScreensharePlatformView(
    private val screenSharePeer: RtkMeetingParticipant,
    private val context: Context
) : DefaultLifecycleObserver, PlatformView {

    private var screenShareView: RtkScreenShareView? = null

    override fun onFlutterViewAttached(ssView: View) {
        super.onFlutterViewAttached(ssView)

        val frameLayoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        if (ssView != null) {
            ssView?.layoutParams = frameLayoutParams
        }
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        if(screenShareView!=null) {
            screenShareView = null
        }
    }

    override fun getView(): View? {
        if (screenShareView == null){
            screenShareView = RtkScreenShareView(screenSharePeer,context)
        }
        return screenShareView
    }

    override fun dispose() {
        if(screenShareView!=null){
            screenShareView = null
        }
    }
}