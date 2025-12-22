import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RtkRegularTileGridDelegate extends SliverGridDelegate {
  final int activeParticipantCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final BuildContext context;
  RtkRegularTileGridDelegate({
    required this.context,
    required this.activeParticipantCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });
  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    int crossAxisCount = 1;
    int mainAxisCount = 1;

    if (activeParticipantCount == 1) {
      crossAxisCount = mainAxisCount = 1;
    } else if (activeParticipantCount == 2) {
      if (isPortrait) {
        mainAxisCount = 2;
        crossAxisCount = 1;
      } else {
        mainAxisCount = 1;
        crossAxisCount = 2;
      }
    } else if (activeParticipantCount == 3 || activeParticipantCount == 4) {
      if (isPortrait) {
        mainAxisCount = crossAxisCount = 2;
      } else {
        crossAxisCount = 3;
        if (activeParticipantCount == 3) {
          mainAxisCount = 1;
        }
        if (activeParticipantCount == 4) {
          mainAxisCount = 2;
        }
      }
    } else {
      if (isPortrait) {
        mainAxisCount = 3;
        crossAxisCount = 2;
      } else {
        mainAxisCount = 2;
        crossAxisCount = 3;
      }
    }

    double availableMainAxisExtent = constraints.viewportMainAxisExtent -
        (mainAxisSpacing * (mainAxisCount - 1));
    double availableCrossAxisExtent =
        constraints.crossAxisExtent - (crossAxisSpacing * (crossAxisCount - 1));

    double mainAxisExtent = availableMainAxisExtent / mainAxisCount;
    double crossAxisExtent = availableCrossAxisExtent / crossAxisCount;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: mainAxisExtent + mainAxisSpacing,
      crossAxisStride: crossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: mainAxisExtent,
      childCrossAxisExtent: crossAxisExtent,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
