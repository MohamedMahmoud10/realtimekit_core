import Flutter
import RealtimeKitFlutterCoreKMM

class RtkScreenshareViewFactory: NSObject, FlutterPlatformViewFactory {
    let mobileClient: CoreRealtimeKitClient

    init(client: CoreRealtimeKitClient) {
        mobileClient = client
    }

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
