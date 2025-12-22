import 'package:flutter/material.dart';

class CustomPainterWidget extends StatefulWidget {
  final Size size;
  final Color borderColor;
  final Color color1;
  final Color color2;

  const CustomPainterWidget({
    super.key,
    this.size = const Size(48, 48),
    this.borderColor = Colors.black,
    required this.color1,
    required this.color2,
  });

  @override
  CustomPainterWidgetState createState() => CustomPainterWidgetState();
}

class CustomPainterWidgetState extends State<CustomPainterWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomPainter(
        widget.size,
        widget.borderColor,
        widget.color1,
        widget.color2,
      ),
      child: const SizedBox.shrink(),
    );
  }
}

class _CustomPainter extends CustomPainter {
  final Size size;
  final Color borderColor;
  final Color color1;
  final Color color2;
  _CustomPainter(this.size, this.borderColor, this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const halfAngle = 3.14;

    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.0,
      halfAngle,
      true,
      paint1,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      halfAngle,
      3.14,
      true,
      paint2,
    );

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}
