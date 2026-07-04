import Flutter
import RealtimeKitFlutterCoreKMM

class RtkPluginViewFactory: NSObject, FlutterPlatformViewFactory {
    // Read the live client dynamically so views created after a rejoin (which
    // rebuilds the native client) bind to the current client, not a stale one.
    var mobileClient: CoreRealtimeKitClient { RtkClientProvider.shared.core }

    init(client _: CoreRealtimeKitClient) {}

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
