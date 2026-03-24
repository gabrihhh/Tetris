import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/constants.dart';
import '../logic/piece_controller.dart';

class PieceComponent extends PositionComponent {
  final PieceController controller;
  double cellSize = 30.0;

  PieceComponent({required this.controller});

  @override
  void render(Canvas canvas) {
    final color = controller.currentPiece.color;
    for (final (col, row) in controller.absoluteCells) {
      final visibleRow = row - TetrisConstants.hiddenRows;
      if (visibleRow < 0) continue;
      _drawCell(canvas, col, visibleRow, color);
    }
  }

  void _drawCell(Canvas canvas, int col, int row, Color color) {
    final x = col * cellSize;
    final y = row * cellSize;
    final rect = Rect.fromLTWH(x + 1, y + 1, cellSize - 2, cellSize - 2);
    canvas.drawRect(rect, Paint()..color = color);
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white24
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}

class GhostPieceComponent extends PositionComponent {
  final PieceController controller;
  double cellSize = 30.0;

  GhostPieceComponent({required this.controller});

  @override
  void render(Canvas canvas) {
    for (final (col, row) in controller.ghostCells) {
      final visibleRow = row - TetrisConstants.hiddenRows;
      if (visibleRow < 0) continue;
      _drawCell(canvas, col, visibleRow);
    }
  }

  void _drawCell(Canvas canvas, int col, int row) {
    final x = col * cellSize;
    final y = row * cellSize;
    final rect = Rect.fromLTWH(x + 1, y + 1, cellSize - 2, cellSize - 2);
    canvas.drawRect(
      rect,
      Paint()
        ..color = TetrisConstants.ghostColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}
