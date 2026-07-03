// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkThemeConfigurations {
  final RtkColorToken colorToken;
  bool isSelected;
  final int id;
  RtkThemeConfigurations({
    required this.colorToken,
    this.isSelected = false,
    required this.id,
  });
}

class RtkThemeNotifer extends Notifier<RtkThemeConfigurations> {
  final List<RtkThemeConfigurations> _configurations = [
    RtkThemeConfigurations(
      id: 0,
      colorToken: RtkColorToken(
        backgroundColor: const Color(0xFF0B0B0B),
        brandColor: const Color(0xFFF17F1F),
        textOnBrand: Colors.white,
        textOnBackground: Colors.white,
      ),
    ),
    RtkThemeConfigurations(
      id: 1,
      colorToken: RtkColorToken(
        backgroundColor: const Color(0xFF0B0B0B),
        brandColor: const Color(0xFF2160FD),
        textOnBrand: Colors.white,
        textOnBackground: Colors.white,
      ),
    ),
    RtkThemeConfigurations(
      id: 2,
      colorToken: RtkColorToken(
        backgroundColor: const Color(0xFFFFFCF8),
        brandColor: const Color(0xFFFFB793),
        textOnBackground: Colors.black,
        textOnBrand: Colors.black,
      ),
    ),
    RtkThemeConfigurations(
      id: 3,
      colorToken: RtkColorToken(
        backgroundColor: const Color(0xFF58C55D),
        brandColor: const Color(0xFFFFFFFF),
        textOnBackground: Colors.black,
        textOnBrand: Colors.black,
      ),
    ),
  ];

  @override
  RtkThemeConfigurations build() {
    return _configurations[0];
  }

  List<RtkThemeConfigurations> get configurations => _configurations;

  void selectConfiguration(int id) {
    for (final configurations in _configurations) {
      if (configurations.id == id) {
        configurations.isSelected = true;
        continue;
      }
      configurations.isSelected = false;
    }
    state = _configurations.firstWhere((element) => element.isSelected);
  }
}

final rtkThemeProvider =
    NotifierProvider<RtkThemeNotifer, RtkThemeConfigurations>(
      () => RtkThemeNotifer(),
    );
