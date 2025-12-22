import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppTheme(globalDesignToken.colorToken).theme.primaryColor,
      ),
    );
  }
}
