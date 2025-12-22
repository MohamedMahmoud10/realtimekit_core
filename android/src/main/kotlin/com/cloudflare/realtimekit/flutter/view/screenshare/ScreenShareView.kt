import android.content.Context
import android.view.ViewGroup
import android.widget.FrameLayout
import com.cloudflare.realtimekit.RtkMeetingParticipant
import com.cloudflare.realtimekit.participants.RtkParticipantUpdateListener
import io.dyte.flutter.R

class RtkScreenShareView(
    private val rtkParticipant: RtkMeetingParticipant,
    context: Context,
) : FrameLayout(context) {

    private var mRtkScreenShareViewContainer: FrameLayout

    init {
        inflate(context, R.layout.screenshare_view, this)
        mRtkScreenShareViewContainer = findViewById(R.id.screen_share_view)
        refreshScreenShareView(rtkParticipant)
        attachListenerToVideoView()
    }


    private fun attachListenerToVideoView() {
        rtkParticipant.addParticipantUpdateListener(object : RtkParticipantUpdateListener {

            override fun onScreenShareUpdate(
                participant: RtkMeetingParticipant,
                isEnabled: Boolean
            ) {
                super.onScreenShareUpdate(participant, isEnabled)
                if (isEnabled){
                    refreshScreenShareView(rtkParticipant)
                } else {
                    rtkParticipant.removeParticipantUpdateListener(this)
                }
            }
        })
    }

    private fun refreshScreenShareView(rtkParticipant: RtkMeetingParticipant) {
        val screenShareView = rtkParticipant.getScreenShareVideoView()
        println("screenShareView present?: ${screenShareView != null}")
        mRtkScreenShareViewContainer.removeAllViews()
        (screenShareView?.parent as? ViewGroup)?.removeView(screenShareView)
        screenShareView?.let {
            mRtkScreenShareViewContainer.addView(it)
            it.renderVideo()
        }
    }

}