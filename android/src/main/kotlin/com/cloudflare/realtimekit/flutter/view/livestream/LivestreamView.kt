package com.cloudflare.realtimekit.flutter.view.livestream

import android.content.Context
import android.net.Uri
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.widget.FrameLayout
import io.dyte.flutter.R

class RtkLivestreamView(private val url: String?, private val context: Context) :
  FrameLayout(context) {
  private val mDyteLivestreamViewContainer: FrameLayout

  init {
    inflate(context, R.layout.livestream_view, this)
    mDyteLivestreamViewContainer = findViewById(R.id.livestream_view)
    val surface = SurfaceView(context)
    surface.holder.addCallback(object : SurfaceHolder.Callback {
      override fun surfaceCreated(holder: SurfaceHolder) {
        url.let {}
      }

      override fun surfaceChanged(p0: SurfaceHolder, p1: Int, p2: Int, p3: Int) {

      }

      override fun surfaceDestroyed(p0: SurfaceHolder) {

      }
    })
    mDyteLivestreamViewContainer.addView(surface)
  }
}

