import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/plugin_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginNotifier extends Notifier<PluginStates>
    implements RtkPluginsEventListener {
  @override
  PluginStates build() {
    return InitialPluginState();
  }

  @override
  void onPluginActivated(RtkPlugin plugin) {
    state = OnPluginActivated(plugin);
  }

  @override
  void onPluginDeactivated(RtkPlugin plugin) {
    state = OnPluginDeactivated(plugin);
  }

  @override
  void onPluginFileRequest(RtkPlugin plugin) {
    state = OnPluginFileRequest(plugin);
  }

  @override
  void onPluginMessage(RtkPlugin plugin, String eventName, String data) {
    state = OnPluginMessage(plugin, eventName, data);
  }
}
