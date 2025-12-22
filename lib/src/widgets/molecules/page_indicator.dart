import 'package:realtimekit_ui/src/di/di.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final double dotSize;
  final double spacing;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    required this.pageCount,
    this.dotSize = 8.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? textColorSwatch.shade900
                : textColorSwatch.shade600,
          ),
        );
      }),
    );
  }
}
