import 'package:realtimekit_ui/realtimekit_ui.dart';

abstract class PluginStates {}

class InitialPluginState extends PluginStates {}

class OnPluginActivated extends PluginStates {
  final RtkPlugin plugin;

  OnPluginActivated(this.plugin);
}

class OnPluginDeactivated extends PluginStates {
  final RtkPlugin plugin;

  OnPluginDeactivated(this.plugin);
}

class OnPluginFileRequest extends PluginStates {
  final RtkPlugin plugin;

  OnPluginFileRequest(this.plugin);
}

class OnPluginMessage extends PluginStates {
  final RtkPlugin plugin;
  final String eventName;
  final String data;

  OnPluginMessage(this.plugin, this.eventName, this.data);
}
