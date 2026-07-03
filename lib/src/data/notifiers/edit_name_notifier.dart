import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class EditNameNotifier extends Notifier<String> {
  String _name = "";

  String get name => _name.trim();

  onChanged(String editedName) {
    _name = editedName;
    state = _name;
  }

  @override
  String build() {
    _name = rtkMeeting.localUser.name;
    return name;
  }
}
