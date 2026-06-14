import 'package:flutter/material.dart';

class SohraiDivider extends StatelessWidget {
  final Color color;
  final double height;

  const SohraiDivider({
    super.key,
    required this.color,
    this.height = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _SohraiPainter(color: color),
    );
  }
}

class _SohraiPainter extends CustomPainter {
  final Color color;

  _SohraiPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double patternWidth = 16.0;
    final int count = (size.width / patternWidth).ceil();
    final double midY = size.height / 2;

    for (int i = 0; i < count; i++) {
      final double startX = i * patternWidth;
      
      // Draw a diamond
      final path = Path()
        ..moveTo(startX + patternWidth / 2, midY - size.height / 2) // Top
        ..lineTo(startX + patternWidth, midY) // Right
        ..lineTo(startX + patternWidth / 2, midY + size.height / 2) // Bottom
        ..lineTo(startX, midY) // Left
        ..close();
        
      canvas.drawPath(path, paint);

      // Draw a tiny secondary circle/dot between diamonds
      if (i < count - 1) {
        canvas.drawCircle(
          Offset(startX + patternWidth, midY),
          1.0,
          paint..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
