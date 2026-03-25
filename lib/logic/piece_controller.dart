import '../game/constants.dart';
import 'board.dart';
import 'tetrimino.dart';

class PieceController {
  final Board board;

  late Tetrimino currentPiece;
  int rotationIndex = 0;
  int col = 0;
  int row = 0;

  double _lockTimer = 0;
  int _lockResets = 0;
  bool _isOnGround = false;

  PieceController({required this.board});

  List<(int, int)> get absoluteCells {
    return currentPiece.cellsForRotation(rotationIndex).map((cell) {
      final (dc, dr) = cell;
      return (col + dc, row + dr);
    }).toList();
  }

  List<(int, int)> get ghostCells {
    int ghostRow = row;
    while (true) {
      final testCells = currentPiece.cellsForRotation(rotationIndex).map((c) {
        final (dc, dr) = c;
        return (col + dc, ghostRow + dr + 1);
      }).toList();
      if (!board.isValidPosition(testCells)) break;
      ghostRow++;
    }
    return currentPiece.cellsForRotation(rotationIndex).map((c) {
      final (dc, dr) = c;
      return (col + dc, ghostRow + dr);
    }).toList();
  }

  bool moveLeft() {
    final testCells = currentPiece.cellsForRotation(rotationIndex).map((c) {
      final (dc, dr) = c;
      return (col + dc - 1, row + dr);
    }).toList();
    if (!board.isValidPosition(testCells)) return false;
    col--;
    _resetLockDelayIfOnGround();
    return true;
  }

  bool moveRight() {
    final testCells = currentPiece.cellsForRotation(rotationIndex).map((c) {
      final (dc, dr) = c;
      return (col + dc + 1, row + dr);
    }).toList();
    if (!board.isValidPosition(testCells)) return false;
    col++;
    _resetLockDelayIfOnGround();
    return true;
  }

  bool moveDown() {
    final testCells = currentPiece.cellsForRotation(rotationIndex).map((c) {
      final (dc, dr) = c;
      return (col + dc, row + dr + 1);
    }).toList();
    if (!board.isValidPosition(testCells)) {
      _isOnGround = true;
      return false;
    }
    row++;
    _isOnGround = false;
    _lockTimer = 0;
    return true;
  }

  bool rotateClockwise() {
    final nextRotation = (rotationIndex + 1) % 4;
    if (_tryRotation(nextRotation)) {
      rotationIndex = nextRotation;
      _resetLockDelayIfOnGround();
      return true;
    }
    return false;
  }

  int hardDrop() {
    int dropped = 0;
    while (moveDown()) {
      dropped++;
    }
    return dropped;
  }

  /// Returns true when the lock delay expires and the piece should be locked.
  bool update(double dt) {
    if (!_isOnGround) return false;
    _lockTimer += dt;
    return _lockTimer >= TetrisConstants.lockDelaySeconds;
  }

  void spawn(Tetrimino piece) {
    currentPiece = piece;
    rotationIndex = 0;
    col = TetrisConstants.boardCols ~/ 2 - 2;
    row = TetrisConstants.hiddenRows; // spawn na primeira linha visível
    _lockTimer = 0;
    _lockResets = 0;
    _isOnGround = false;
  }

  bool _tryRotation(int nextRotation) {
    // Wall kicks + extra downward kick for pieces near the top of the board
    final kicks = [
      ..._wallKicks(rotationIndex, nextRotation),
      (0, 1),  // kick down (useful when near top)
      (0, 2),  // kick down 2
    ];
    for (final (dc, dr) in kicks) {
      final testCells =
          currentPiece.cellsForRotation(nextRotation).map((c) {
        final (tc, tr) = c;
        return (col + tc + dc, row + tr + dr);
      }).toList();
      if (board.isValidPosition(testCells)) {
        col += dc;
        row += dr;
        return true;
      }
    }
    return false;
  }

  void _resetLockDelayIfOnGround() {
    if (_isOnGround && _lockResets < TetrisConstants.maxLockResets) {
      _lockTimer = 0;
      _lockResets++;
    }
  }

  // Basic SRS wall kick offsets (same for J, L, S, T, Z)
  // For I-piece a different table is used but this covers most cases
  List<(int, int)> _wallKicks(int from, int to) {
    if (currentPiece.type == TetriminoType.I) {
      return _iWallKicks(from, to);
    }
    final table = <(int, int), List<(int, int)>>{
      (0, 1): [(0, 0), (-1, 0), (-1, 1), (0, -2), (-1, -2)],
      (1, 0): [(0, 0), (1, 0), (1, -1), (0, 2), (1, 2)],
      (1, 2): [(0, 0), (1, 0), (1, -1), (0, 2), (1, 2)],
      (2, 1): [(0, 0), (-1, 0), (-1, 1), (0, -2), (-1, -2)],
      (2, 3): [(0, 0), (1, 0), (1, 1), (0, -2), (1, -2)],
      (3, 2): [(0, 0), (-1, 0), (-1, -1), (0, 2), (-1, 2)],
      (3, 0): [(0, 0), (-1, 0), (-1, -1), (0, 2), (-1, 2)],
      (0, 3): [(0, 0), (1, 0), (1, 1), (0, -2), (1, -2)],
    };
    return table[(from, to)] ?? [(0, 0)];
  }

  List<(int, int)> _iWallKicks(int from, int to) {
    final table = <(int, int), List<(int, int)>>{
      (0, 1): [(0, 0), (-2, 0), (1, 0), (-2, -1), (1, 2)],
      (1, 0): [(0, 0), (2, 0), (-1, 0), (2, 1), (-1, -2)],
      (1, 2): [(0, 0), (-1, 0), (2, 0), (-1, 2), (2, -1)],
      (2, 1): [(0, 0), (1, 0), (-2, 0), (1, -2), (-2, 1)],
      (2, 3): [(0, 0), (2, 0), (-1, 0), (2, 1), (-1, -2)],
      (3, 2): [(0, 0), (-2, 0), (1, 0), (-2, -1), (1, 2)],
      (3, 0): [(0, 0), (1, 0), (-2, 0), (1, -2), (-2, 1)],
      (0, 3): [(0, 0), (-1, 0), (2, 0), (-1, 2), (2, -1)],
    };
    return table[(from, to)] ?? [(0, 0)];
  }
}
