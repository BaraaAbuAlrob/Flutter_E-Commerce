import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class MapPreviewWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color pinColor;
  final bool isCircular;
  final bool isSelected;
  final double borderRadius;

  const MapPreviewWidget({
    super.key,
    this.width = 56,
    this.height = 56,
    this.pinColor = const Color(0xFF00D2B4),
    this.isCircular = true,
    this.isSelected = false,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : AppColors.grey300,
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: isCircular
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(borderRadius - 1),
        child: CustomPaint(
          size: Size(width, height),
          painter: _MapBackgroundPainter(),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pinColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: pinColor,
                size: isCircular ? (width * 0.42) : (height * 0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background fill
    final bgPaint = Paint()..color = const Color(0xFFF0F4F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle water / park patches
    final patchPaint = Paint()
      ..color = const Color(0xFFDCEAF5)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.45,
        size.width * 0.4,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, patchPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.7, 0)
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.25,
        size.width,
        size.height * 0.35,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path2, patchPaint);

    // Road / street lines
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = size.width * 0.14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Main road
    final mainRoad = Path()
      ..moveTo(-size.width * 0.1, size.height * 0.3)
      ..lineTo(size.width * 1.1, size.height * 0.85);

    canvas.drawPath(mainRoad, roadBorderPaint);
    canvas.drawPath(mainRoad, roadPaint);

    // Cross road
    final crossRoad = Path()
      ..moveTo(size.width * 0.2, -size.height * 0.1)
      ..lineTo(size.width * 0.8, size.height * 1.1);

    canvas.drawPath(crossRoad, roadBorderPaint);
    canvas.drawPath(crossRoad, roadPaint);

    // Minor street
    final minorRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.07
      ..style = PaintingStyle.stroke;

    final minorRoad = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.1, size.height);
    canvas.drawPath(minorRoad, minorRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
