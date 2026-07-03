import Flutter
import RealtimeKitFlutterCoreKMM

class RtkScreenshareView: NSObject, FlutterPlatformView {
    let screensharePeer: CoreRtkMeetingParticipant
    init(peer: CoreRtkMeetingParticipant) {
        screensharePeer = peer
    }

    func view() -> UIView {
        return screensharePeer.getScreenShareVideoView()!
    }
}
