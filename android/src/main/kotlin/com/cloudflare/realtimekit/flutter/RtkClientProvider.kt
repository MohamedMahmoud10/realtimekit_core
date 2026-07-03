package com.cloudflare.realtimekit.flutter

import com.cloudflare.realtimekit.RealtimeKitClient
import com.cloudflare.realtimekit.RtkClient

/**
 * Single source of truth for the *current* native meeting client.
 *
 * The Cloudflare RealtimeKit SDK builds one [RealtimeKitClient] per meeting and
 * cannot be re-`init()`'d once it has been used: a second `init()` on the same
 * instance never completes, which surfaces in the Flutter UI as an infinite
 * loading spinner when a user leaves a meeting and joins again (only an app
 * restart recovers it, because that rebuilds the client).
 *
 * To support join -> leave -> join again we rebuild the client when a meeting is
 * released (see [FlutterCorePlugin]) and publish it here. The method-call handler
 * and the platform-view factories read from this holder **dynamically** so they
 * always operate on the live client rather than a stale captured reference.
 */
object RtkClientProvider {
    @Volatile
    var rtkClient: RtkClient? = null

    @Volatile
    var realtimeClient: RealtimeKitClient? = null

    fun requireRtkClient(): RtkClient =
        rtkClient ?: error("RtkClient has not been initialized yet")

    fun requireRealtimeClient(): RealtimeKitClient =
        realtimeClient ?: error("RealtimeKitClient has not been initialized yet")
}
