package com.cloudflare.realtimekit.flutter.view.videoview

import android.content.Context
import com.cloudflare.realtimekit.RealtimeKitClient
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RtkVideoViewFactory(
    private val mobileClient: RealtimeKitClient,
    ) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val map = args as Map<String, Any?>
        val id = map["id"] as String?
        val isSelfParticipant = map["isSelfParticipant"] as Boolean
        val participant =
            if (!isSelfParticipant && id != null)
                mobileClient.participants.joined.find { it.id == id }!!
            else
                mobileClient.localUser
        if (context == null) {
            throw AssertionError("context for DyteVideoView is null!")
        }

        return RtkVideoPlatformView(context, participant)

    }

}


