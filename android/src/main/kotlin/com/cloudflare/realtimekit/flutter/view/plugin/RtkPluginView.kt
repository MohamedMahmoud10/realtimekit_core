package com.cloudflare.realtimekit.flutter.view.plugin

import android.content.Context
import android.view.ViewGroup
import android.widget.FrameLayout
import com.cloudflare.realtimekit.plugins.RtkPlugin
import io.dyte.flutter.R

class RtkPluginView(
    private val plugin: RtkPlugin,
    context: Context,
) : FrameLayout(context) {

    private var mDytePluginViewContainer: FrameLayout

    init {
        inflate(context, R.layout.plugin_view, this)
        mDytePluginViewContainer = findViewById(R.id.plugin_view)
        renderPlugin()
    }


    private fun renderPlugin() {
        val pluginView = plugin.getPluginView()
        mDytePluginViewContainer.removeAllViews()
        (pluginView?.parent as? ViewGroup)?.removeView(pluginView)
        pluginView.let {
            mDytePluginViewContainer.addView(it)
        }
    }

}