package com.cloudflare.realtimekit.flutter.view.plugin
import android.content.Context
import com.cloudflare.realtimekit.RealtimeKitClient
import com.cloudflare.realtimekit.flutter.RtkClientProvider
import com.cloudflare.realtimekit.plugins.RtkPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RtkPluginViewFactory(private val mobileClient: RealtimeKitClient) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        // Live client (rebuilt per meeting), not the captured one.
        val mobileClient = RtkClientProvider.requireRealtimeClient()
        val creationParams = args as Map<String?, Any?>
        val dytePlugin: RtkPlugin =
            mobileClient.plugins.all.find { it.id == creationParams["id"] }!!
        if (context == null) {
            throw AssertionError("context for DytePluginView is null!")
        }
        return RtkPluginPlatformView(dytePlugin, context)
    }

}