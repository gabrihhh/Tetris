import 'package:flutter/material.dart';
import '../game/constants.dart';

enum TetriminoType { I, O, T, S, Z, J, L }

class Tetrimino {
  final TetriminoType type;
  final Color color;
  final List<List<(int, int)>> rotations;

  const Tetrimino._({
    required this.type,
    required this.color,
    required this.rotations,
  });

  factory Tetrimino.fromType(TetriminoType type) {
    switch (type) {
      case TetriminoType.I:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['I']!,
          rotations: [
            [(0, 1), (1, 1), (2, 1), (3, 1)],
            [(2, 0), (2, 1), (2, 2), (2, 3)],
            [(0, 2), (1, 2), (2, 2), (3, 2)],
            [(1, 0), (1, 1), (1, 2), (1, 3)],
          ],
        );
      case TetriminoType.O:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['O']!,
          rotations: [
            [(1, 0), (2, 0), (1, 1), (2, 1)],
            [(1, 0), (2, 0), (1, 1), (2, 1)],
            [(1, 0), (2, 0), (1, 1), (2, 1)],
            [(1, 0), (2, 0), (1, 1), (2, 1)],
          ],
        );
      case TetriminoType.T:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['T']!,
          rotations: [
            [(0, 1), (1, 1), (2, 1), (1, 0)],
            [(1, 0), (1, 1), (1, 2), (2, 1)],
            [(0, 1), (1, 1), (2, 1), (1, 2)],
            [(1, 0), (1, 1), (1, 2), (0, 1)],
          ],
        );
      case TetriminoType.S:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['S']!,
          rotations: [
            [(1, 0), (2, 0), (0, 1), (1, 1)],
            [(1, 0), (1, 1), (2, 1), (2, 2)],
            [(1, 1), (2, 1), (0, 2), (1, 2)],
            [(0, 0), (0, 1), (1, 1), (1, 2)],
          ],
        );
      case TetriminoType.Z:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['Z']!,
          rotations: [
            [(0, 0), (1, 0), (1, 1), (2, 1)],
            [(2, 0), (1, 1), (2, 1), (1, 2)],
            [(0, 1), (1, 1), (1, 2), (2, 2)],
            [(1, 0), (0, 1), (1, 1), (0, 2)],
          ],
        );
      case TetriminoType.J:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['J']!,
          rotations: [
            [(0, 0), (0, 1), (1, 1), (2, 1)],
            [(1, 0), (2, 0), (1, 1), (1, 2)],
            [(0, 1), (1, 1), (2, 1), (2, 2)],
            [(1, 0), (1, 1), (0, 2), (1, 2)],
          ],
        );
      case TetriminoType.L:
        return Tetrimino._(
          type: type,
          color: TetrisConstants.pieceColors['L']!,
          rotations: [
            [(2, 0), (0, 1), (1, 1), (2, 1)],
            [(1, 0), (1, 1), (1, 2), (2, 2)],
            [(0, 1), (1, 1), (2, 1), (0, 2)],
            [(0, 0), (1, 0), (1, 1), (1, 2)],
          ],
        );
    }
  }

  List<(int, int)> cellsForRotation(int rotationIndex) =>
      rotations[rotationIndex % 4];
}
