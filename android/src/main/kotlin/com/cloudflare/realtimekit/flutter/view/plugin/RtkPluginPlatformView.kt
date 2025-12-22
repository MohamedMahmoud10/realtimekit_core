package com.cloudflare.realtimekit.flutter.view.plugin

import android.content.Context
import android.view.View
import com.cloudflare.realtimekit.plugins.RtkPlugin
import io.flutter.plugin.platform.PlatformView

class RtkPluginPlatformView (private val plugin: RtkPlugin, private val context: Context) : PlatformView{
    private var pluginView: RtkPluginView? = null

    override fun getView(): View? {
        if (pluginView == null) {
            pluginView = RtkPluginView(plugin, context)
        }
        return pluginView
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
    }

    override fun dispose() {
        pluginView = null
    }
}