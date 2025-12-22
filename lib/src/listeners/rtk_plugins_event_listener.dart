import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkPluginsEventListener extends RtkListener {
  void onPluginActivated(RtkPlugin plugin) {}
  void onPluginDeactivated(RtkPlugin plugin) {}
  void onPluginMessage(RtkPlugin plugin, String eventName, String data) {}
  void onPluginFileRequest(RtkPlugin plugin) {}
}

class RtkPluginsController extends RtkPluginsEventListener {
  RtkPluginsController._();

  static final RtkPluginsController instance = RtkPluginsController._();

  List<RtkPlugin> _activePlugins = [];

  List<RtkPlugin> get activePlugins => List.unmodifiable(_activePlugins);

  @override
  void onPluginActivated(RtkPlugin plugin) {
    _activePlugins = [..._activePlugins, plugin];
  }

  @override
  void onPluginDeactivated(RtkPlugin plugin) {
    _activePlugins = _activePlugins.where((p) => p != plugin).toList();
  }

  void dispose() {
    _activePlugins = [];
  }
}
