import 'dart:io' show Platform;

import 'package:file_picker/file_picker.dart';

/// - iOS prefers file path/URL strings.
/// - Android prefers content:// URIs when available, falling back to path.
String resolveShareUri(PlatformFile file) {
  if (Platform.isIOS) {
    return file.path ?? '';
  }
  final id = file.identifier;
  if (id != null && id.startsWith('content://')) return id;
  return file.path ?? id ?? '';
}
