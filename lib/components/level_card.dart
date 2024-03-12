import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class LevelCard extends PositionComponent with TapCallbacks {
  final String levelName;
  final VoidCallback onPressed;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final RRect _rRect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  LevelCard({
    required this.levelName,
    required this.onPressed,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.center,
  }) : _textDrawable = TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w800,
          ),
        ).toTextPainter(levelName) {
    size = Vector2(100, 100);
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    _rRect = RRect.fromLTRBR(0, 0, size.x, size.y, const Radius.circular(10));
    _bgPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rRect, _bgPaint);
    canvas.drawRRect(_rRect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    onPressed.call();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}
