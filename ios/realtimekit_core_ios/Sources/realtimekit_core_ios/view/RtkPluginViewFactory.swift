import Flutter
import RealtimeKitFlutterCoreKMM

class RtkPluginViewFactory: NSObject, FlutterPlatformViewFactory {
    let mobileClient: CoreRealtimeKitClient

    init(client: CoreRealtimeKitClient) {
        mobileClient = client
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        guard let creationParams = args as? [String: Any?],
              let id = creationParams["id"] as? String,
              let dytePlugin = mobileClient.plugins.all.first(where: { $0.id == id })
        else {
            fatalError("Failed to find DytePlugin in mobileClient.plugins")
        }
        return DytePluginView(frame: frame, viewIdentifier: viewId, plugin: dytePlugin)
    }
}
