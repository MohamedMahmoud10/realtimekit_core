package com.cloudflare.realtimekit.flutter.view.videoview

import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class VideoViewController : MethodChannel.MethodCallHandler {

    private fun refreshVideoView(viewId: Int){
        val targetView = FlutterEngineCache.getInstance()["DyteFlutterEngine"]!!
            .platformViewsController.getPlatformViewById(viewId) as RtkVideoView?
        targetView?.refreshVideo()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "refreshVideoView" -> {
                val arguments = call.arguments as Map<String, Any?>
                val viewId = arguments["viewId"]
                if (viewId != null){
                    refreshVideoView(viewId as Int)
                }
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}