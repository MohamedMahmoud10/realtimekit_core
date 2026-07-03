import 'package:flutter/material.dart';

class RtkShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  const RtkShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
