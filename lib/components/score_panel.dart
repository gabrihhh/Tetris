import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../logic/score_manager.dart';

class ScorePanel extends PositionComponent {
  final ScoreManager scoreManager;

  static const double panelWidth = 150;
  static const double panelHeight = 100;

  ScorePanel({required this.scoreManager});

  @override
  void render(Canvas canvas) {
    _drawLabel(canvas, 'SCORE', scoreManager.score.toString(), 0);
    _drawLabel(canvas, 'LEVEL', scoreManager.level.toString(), 38);
    _drawLabel(canvas, 'LINES', scoreManager.totalLinesCleared.toString(), 76);
  }

  void _drawLabel(Canvas canvas, String label, String value, double y) {
    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(0, y));

    final valuePainter = TextPainter(
      text: TextSpan(
        text: value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    valuePainter.paint(canvas, Offset(0, y + 14));
  }
}
