import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/constants.dart';
import '../logic/board.dart';
import '../logic/tetrimino.dart';

class BoardComponent extends PositionComponent {
  final Board board;
  double cellSize = 30.0;

  BoardComponent({required this.board});

  @override
  void render(Canvas canvas) {
    final boardWidth = TetrisConstants.boardCols * cellSize;
    final boardHeight = TetrisConstants.boardRows * cellSize;

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, boardWidth, boardHeight),
      Paint()..color = TetrisConstants.background,
    );

    // Locked cells
    for (int r = 0; r < TetrisConstants.boardRows; r++) {
      for (int c = 0; c < TetrisConstants.boardCols; c++) {
        final type = board.cellAt(c, r + TetrisConstants.hiddenRows);
        if (type != null) {
          _drawCell(canvas, c, r, _colorForType(type));
        }
      }
    }

    // Grid lines
    final gridPaint = Paint()
      ..color = TetrisConstants.gridLine
      ..strokeWidth = 0.5;
    for (int c = 0; c <= TetrisConstants.boardCols; c++) {
      canvas.drawLine(
        Offset(c * cellSize, 0),
        Offset(c * cellSize, boardHeight),
        gridPaint,
      );
    }
    for (int r = 0; r <= TetrisConstants.boardRows; r++) {
      canvas.drawLine(
        Offset(0, r * cellSize),
        Offset(boardWidth, r * cellSize),
        gridPaint,
      );
    }

    // Border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, boardWidth, boardHeight),
      Paint()
        ..color = Colors.white24
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
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

  Color _colorForType(TetriminoType type) =>
      TetrisConstants.pieceColors[type.name] ?? Colors.white;
}
