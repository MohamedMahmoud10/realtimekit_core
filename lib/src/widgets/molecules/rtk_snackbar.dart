import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';

void showBottomSheetWithWidget(BuildContext context, Widget widget) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          borderToken.getRadius(BorderSize.two),
        ),
        topRight: Radius.circular(
          borderToken.getRadius(BorderSize.two),
        ),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: context.height * 0.1,
        decoration: BoxDecoration(
          color: backgroundColorSwatch.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              borderToken.getRadius(BorderSize.two),
            ),
            topRight: Radius.circular(
              borderToken.getRadius(BorderSize.two),
            ),
          ),
        ),
        child: widget,
      );
    },
  );
}
