import Flutter
import RealtimeKitFlutterCoreKMM

class RtkScreenshareViewFactory: NSObject, FlutterPlatformViewFactory {
    // Read the live client dynamically so views created after a rejoin (which
    // rebuilds the native client) bind to the current client, not a stale one.
    var mobileClient: CoreRealtimeKitClient { RtkClientProvider.shared.core }

    init(client _: CoreRealtimeKitClient) {}

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame _: CGRect, viewIdentifier _: Int64, arguments args: Any?) -> FlutterPlatformView {
        let map = (args as? [String: Any]) ?? [:]
        let id = map["id"] as! String
        let screenshareParticipant = if id == mobileClient.localUser.id {
            mobileClient.localUser
        } else {
            mobileClient.participants.screenShares.first(where: { $0.id == id })
        }
        return RtkScreenshareView(peer: screenshareParticipant as! CoreRtkMeetingParticipant)
    }
}
