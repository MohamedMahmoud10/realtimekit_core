import Flutter
import RealtimeKitFlutterCoreKMM
import WebKit

class DytePluginView: NSObject, FlutterPlatformView {
    private var _view: UIView = .init()

    init(frame _: CGRect, viewIdentifier _: Int64, plugin: CoreRtkPlugin) {
        _view = plugin.getPluginView()!
    }

    func view() -> UIView {
        return _view
    }
}
