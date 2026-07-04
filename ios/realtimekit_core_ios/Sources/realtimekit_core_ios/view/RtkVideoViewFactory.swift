import Flutter
import RealtimeKitFlutterCoreKMM

class RtkVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    // Read the live client dynamically so views created after a rejoin (which
    // rebuilds the native client) bind to the current client, not a stale one.
    var mobileClient: CoreRealtimeKitClient { RtkClientProvider.shared.core }

    init(messenger: FlutterBinaryMessenger, client _: CoreRealtimeKitClient) {
        self.messenger = messenger
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
