import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/constants.dart';
import '../logic/tetrimino.dart';
import '../logic/tetrimino_bag.dart';

class NextPiecePanel extends PositionComponent {
  final TetriminoBag bag;
  double cellSize = 30.0;

  NextPiecePanel({required this.bag});

  @override
  void render(Canvas canvas) {
    final panelSize = TetrisConstants.panelCells * cellSize;
    final previewCellSize = cellSize * 0.8;

    // Panel background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, panelSize, panelSize),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF111111),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, panelSize, panelSize),
        const Radius.circular(4),
      ),
      Paint()
        ..color = Colors.white24
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Label
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'NEXT',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset((panelSize - labelPainter.width) / 2, 8));

    // Next piece preview
    final nextType = bag.peek();
    final piece = Tetrimino.fromType(nextType);
    final cells = piece.cellsForRotation(0);
    final color = piece.color;

    final minCol = cells.map((c) => c.$1).reduce((a, b) => a < b ? a : b);
    final maxCol = cells.map((c) => c.$1).reduce((a, b) => a > b ? a : b);
    final minRow = cells.map((c) => c.$2).reduce((a, b) => a < b ? a : b);
    final maxRow = cells.map((c) => c.$2).reduce((a, b) => a > b ? a : b);

    final pieceWidth = (maxCol - minCol + 1) * previewCellSize;
    final pieceHeight = (maxRow - minRow + 1) * previewCellSize;
    final offsetX = (panelSize - pieceWidth) / 2 - minCol * previewCellSize;
    final offsetY = (panelSize - pieceHeight) / 2 - minRow * previewCellSize + 8;

    for (final (col, row) in cells) {
      final x = offsetX + col * previewCellSize;
      final y = offsetY + row * previewCellSize;
      final rect = Rect.fromLTWH(x + 1, y + 1, previewCellSize - 2, previewCellSize - 2);
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
}
