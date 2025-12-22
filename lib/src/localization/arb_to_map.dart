import 'dart:convert';

import 'package:flutter/services.dart';

class Localize {
  Map<String, dynamic> _arbJson = {};
  Map<String, dynamic> get arbJson => _arbJson;

  Map<String, String> get arbMap => _arbMap;

  final Map<String, String> _arbMap = <String, String>{};

  String _locale = 'en';

  String get locale => _locale;

  Future<Localize> init(String arbPath) async {
    final arbContent = await rootBundle.loadString(arbPath);
    _arbJson = json.decode(arbContent) as Map<String, dynamic>;
    return this;
  }

  Map<String, String> arbToMap() {
    for (final key in arbJson.keys) {
      if (key == '@locale') {
        _locale = arbJson[key] as String;
        continue;
      }
      _arbMap[key] = arbJson[key] as String;
    }
    return arbMap;
  }
}
