package com.cloudflare.realtimekit.flutter.view.screenshare
import android.content.Context
import com.cloudflare.realtimekit.RealtimeKitClient
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RtkScreenshareViewFactory(private val mobileClient: RealtimeKitClient) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String, Any?>
        val peerId = creationParams["id"] as String
        val allPossibleUsers = listOf(mobileClient.localUser) + mobileClient.participants.screenShares
        val screenSharePeer = allPossibleUsers.firstOrNull { it.id == peerId }

        if (context == null || screenSharePeer == null) {
            throw AssertionError("context for RtkScreenShareView is null!")
        }
        return RtkScreensharePlatformView(screenSharePeer, context)
    }
}