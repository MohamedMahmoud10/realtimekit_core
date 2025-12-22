// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class RtkPlugin {
  final RtkPluginApi _rtkPluginApi;
  String id;
  String name;
  String description;
  String picture;
  bool private;
  bool staggered;
  String baseURL;
  bool isActive;
  RtkPlugin(
    this._rtkPluginApi, {
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.private,
    required this.staggered,
    required this.baseURL,
    required this.isActive,
  });

  factory RtkPlugin.fromMap(
      Map<String, dynamic> map, RtkPluginApi rtkPluginApi) {
    if (map.containsKey("plugin")) {
      map = map["plugin"];
    }
    return RtkPlugin(
      rtkPluginApi,
      id: map["id"],
      name: map["name"],
      description: map["description"],
      picture: map["picture"],
      private: map["private"].runtimeType == bool
          ? map["private"]
          : decodeBool(map["private"]),
      staggered: map["staggered"].runtimeType == bool
          ? map["staggered"]
          : decodeBool(map["staggered"]),
      baseURL: map["baseURL"],
      isActive: map["isActive"].runtimeType == bool
          ? map["isActive"]
          : decodeBool(map["isActive"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "picture": picture,
      "private": private,
      "staggered": staggered,
      "baseURL": baseURL,
      "isActive": isActive,
    };
  }

  String toJson() => json.encode(toMap());

  factory RtkPlugin.fromJson(String source, RtkPluginApi rtkPluginApi) =>
      RtkPlugin.fromMap(json.decode(source), rtkPluginApi);

  void activate() => _rtkPluginApi.activate(id);

  void deactivate() => _rtkPluginApi.deactivate(id);

  @override
  bool operator ==(covariant RtkPlugin other) {
    if (identical(this, other)) return true;

    return other._rtkPluginApi == _rtkPluginApi &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.picture == picture &&
        other.private == private &&
        other.staggered == staggered &&
        other.baseURL == baseURL &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return _rtkPluginApi.hashCode ^
        id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        picture.hashCode ^
        private.hashCode ^
        staggered.hashCode ^
        baseURL.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'RtkPlugin(rtkPluginApi: $_rtkPluginApi, id: $id, name: $name, description: $description, picture: $picture, private: $private, staggered: $staggered, baseURL: $baseURL, isActive: $isActive)';
  }
}

abstract class RtkPlugins {
  List<RtkPlugin> get all;
  List<RtkPlugin> get active;
}

abstract class RtkPluginApi {
  void activate(String id);
  void deactivate(String id);
}
