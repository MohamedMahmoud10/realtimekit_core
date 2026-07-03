import Flutter
import RealtimeKitFlutterCoreKMM

class RtkVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    let mobileClient: CoreRealtimeKitClient

    init(messenger: FlutterBinaryMessenger, client: CoreRealtimeKitClient) {
        self.messenger = messenger
        mobileClient = client
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        guard let map = args as? [String: Any?],
              let id = map["id"] as? String?,
              let isSelfParticipant = map["isSelfParticipant"] as? Bool
        else {
            fatalError("Invalid arguments provided")
        }
        let participant: CoreRtkMeetingParticipant
        if !isSelfParticipant && id != nil {
            participant = mobileClient.participants.joined.first(where: { $0.id == id })!
        } else {
            participant = mobileClient.localUser
        }
        return RtkVideoView(frame: frame, viewIdentifier: viewId, participant: participant)
    }
}
