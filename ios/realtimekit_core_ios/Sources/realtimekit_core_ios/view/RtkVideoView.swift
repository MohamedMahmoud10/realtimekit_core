import Flutter
import RealtimeKitFlutterCoreKMM

class RtkVideoView: NSObject, FlutterPlatformView {
    private var _view: UIView?

    let participant: CoreRtkMeetingParticipant

    init(frame _: CGRect, viewIdentifier _: Int64, participant: CoreRtkMeetingParticipant) {
        self.participant = participant
        _view = participant.getVideoView()
        _view?.clipsToBounds = true
        super.init()
    }

    func view() -> UIView {
        if _view == nil {
            _view = participant.getVideoView()
            _view?.clipsToBounds = true
        }
        return _view ?? UIView()
    }
}
