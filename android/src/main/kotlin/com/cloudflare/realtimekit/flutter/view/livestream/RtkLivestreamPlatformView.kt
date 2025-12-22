package com.cloudflare.realtimekit.flutter.view.livestream

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView

class RtkLivestreamPlatformView(private val url: String?, private val context: Context) :
  PlatformView {

  private var livestreamView: RtkLivestreamView? = null

  override fun onFlutterViewAttached(flutterView: View) {
    if (livestreamView == null) {
      livestreamView = RtkLivestreamView(url, context)
    }
    super.onFlutterViewAttached(flutterView)
  }

  override fun getView(): View? {
    if (livestreamView == null) {
      livestreamView = RtkLivestreamView(url, context)
    }
    return livestreamView
  }

  override fun dispose() {
  }
}