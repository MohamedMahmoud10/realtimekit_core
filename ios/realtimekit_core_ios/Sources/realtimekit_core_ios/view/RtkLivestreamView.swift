import Flutter
import Foundation

// class DyteLivestreamView : NSObject, FlutterPlatformView {
//
//    private var _view: UIView
//    var url: String
//    var frame: CGRect
//
//    init(frame: CGRect,
//         viewIdentifier viewId: Int64, url lvsURL: String) {
//
//        self._view = UIView()
//        self.url = lvsURL
//        self.frame = frame
//        super.init()
//    }
//
//    func view() -> UIView {
//        let lvsViewer = DyteLivestreamViewer(frame: frame, url: url)
//        return lvsViewer.loadLivestream(url: url)
//    }
// }

// class DyteLivestreamViewer : UIView {
//
//    let playerView : IVSPlayerView
//    let player : IVSPlayer
//    let url: String

//    init(frame: CGRect, url: String) {
//        playerView = IVSPlayerView()
//        player = IVSPlayer()
//
//        self.url = url
//        super.init(frame: frame)
//
//        playerView.player = player
//        player.delegate = self

//    }

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    func loadLivestream(url lvsURL: String) -> UIView {
//        player.load(URL(string: lvsURL))
//        player.play()
//        return playerView
//    }
// }
