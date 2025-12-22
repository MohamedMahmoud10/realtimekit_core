package com.cloudflare.realtimekit.flutter.view.livestream

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class RtkLivestreamViewFactory() : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
    val map = args as Map<String, Any?>
    val url = map["url"] as String?

    if (context == null) {
      throw AssertionError("context for DyteVideoView is null!")
    }

    return RtkLivestreamPlatformView(
      url, context
    )
  }
}