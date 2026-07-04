import RealtimeKitFlutterCoreKMM

/// Single source of truth for the *current* native meeting client.
///
/// The Cloudflare RealtimeKit (KMM) client is effectively single-use: once a
/// meeting has been initialised on it, calling `doInit` again never completes,
/// which surfaces in the Flutter UI as an infinite loading spinner when a user
/// leaves a meeting and joins again. Previously only an app restart recovered
/// it, because that rebuilt the plugin and, with it, a fresh client.
///
/// To support join -> leave -> join again we rebuild the client when the meeting
/// is released (see `SwiftFlutterCoreIosPlugin`'s `release` handler) and publish
/// it here. The plugin, the platform-view factories and the event handlers all
/// read from this holder **dynamically** so they always operate on the live
/// client rather than a stale captured reference.
///
/// This mirrors the Android fix (`RtkClientProvider` + `rebuildMeetingClient`).
final class RtkClientProvider {
    static let shared = RtkClientProvider()

    /// The current native client. Rebuilt on meeting release.
    private(set) var client: RtkClient

    private init() {
        client = RtkClientBuilder().build()
    }

    /// Convenience accessor for the underlying mobile-core client that the
    /// platform-view factories operate on.
    var core: CoreRealtimeKitClient { client.core }

    /// Builds a brand-new native client so the *next* meeting starts on a clean
    /// instance. Called on `release` (i.e. when leaving a meeting), because the
    /// SDK cannot re-`doInit()` a client once it has been used — the second
    /// `doInit` never completes and the Flutter UI hangs on the loading spinner.
    func rebuild() {
        client = RtkClientBuilder().build()
    }
}
