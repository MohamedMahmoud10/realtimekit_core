import 'package:flutter/material.dart';

class RtkGridViewWidget extends StatefulWidget {
  const RtkGridViewWidget({
    required this.height,
    required this.children,
    required this.width,
    this.spacing = 10,
    super.key,
  })  : assert(
            children.length <= 6, "Active participants can't be more than 6"),
        totalChild = children.length;
  final List<Widget> children;
  final int totalChild;
  final double height;
  final double width;
  final double spacing;

  @override
  State<RtkGridViewWidget> createState() => _RtkGridViewWidgetState();
}

class _RtkGridViewWidgetState extends State<RtkGridViewWidget> {
  late int rows;
  static const maxColumn = 2;

  @override
  void initState() {
    super.initState();
    rows = _calculateRows();
  }

  @override
  Widget build(BuildContext context) {
    rows = _calculateRows();

    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.spacing,
      alignment: WrapAlignment.center,
      children: [
        ...widget.children
            .map((child) => SizedBox(
                  width: _allocateWidthForParticipant(
                      widget.children.indexOf(child) + 1),
                  height: _allocateHeightForParticipants(),
                  child: child,
                ))
            .toList(),
      ],
    );
  }

  double _allocateWidthForParticipant(int participantIndex) {
    final currentRow = (participantIndex ~/ 2) + 1;
    final currentColumn = (participantIndex % 2) + 1;
    if (widget.totalChild <= 0) {
      throw Exception("Invalid number of participants");
    }
    if (widget.totalChild <= maxColumn) {
      return widget.width - (widget.spacing * (maxColumn + 1));
    }
    if (widget.totalChild % 2 == 1) {
      if (currentRow == rows && currentColumn == maxColumn) {
        return widget.width - (widget.spacing * (maxColumn + 1));
      }
    }
    return (widget.width / maxColumn) - (widget.spacing * maxColumn);
  }

  double _allocateHeightForParticipants() {
    if (widget.totalChild <= 0) {
      return throw Exception('Invalid number of participants');
    }
    if (widget.totalChild == 1) {
      return widget.height;
    }

    return (widget.height / rows) - ((widget.spacing * (rows - 1)) / rows);
  }

  int _calculateRows() {
    if (widget.children.length == 1) {
      return 1;
    }
    if (widget.children.length == 2) {
      return 2;
    }
    return (widget.children.length / maxColumn).ceil();
  }
}
