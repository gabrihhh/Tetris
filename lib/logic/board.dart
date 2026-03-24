import '../game/constants.dart';
import 'tetrimino.dart';

class Board {
  static const int _totalRows =
      TetrisConstants.boardRows + TetrisConstants.hiddenRows;

  final List<List<TetriminoType?>> _grid = List.generate(
    _totalRows,
    (_) => List.filled(TetrisConstants.boardCols, null),
  );

  TetriminoType? cellAt(int col, int row) => _grid[row][col];

  bool isValidPosition(List<(int, int)> cells) {
    for (final (col, row) in cells) {
      if (col < 0 || col >= TetrisConstants.boardCols) return false;
      if (row >= _totalRows) return false;
      if (row >= 0 && _grid[row][col] != null) return false;
    }
    return true;
  }

  void lockPiece(List<(int, int)> cells, TetriminoType type) {
    for (final (col, row) in cells) {
      if (row >= 0 && row < _totalRows) {
        _grid[row][col] = type;
      }
    }
  }

  List<int> findFullRows() {
    final full = <int>[];
    for (int row = 0; row < _totalRows; row++) {
      if (_grid[row].every((cell) => cell != null)) {
        full.add(row);
      }
    }
    return full;
  }

  int clearRows(List<int> rows) {
    final rowSet = rows.toSet();
    final remaining = [
      for (int r = 0; r < _totalRows; r++)
        if (!rowSet.contains(r)) _grid[r],
    ];
    final emptyRows = List.generate(
      rows.length,
      (_) => List<TetriminoType?>.filled(TetrisConstants.boardCols, null),
    );
    final newGrid = [...emptyRows, ...remaining];
    for (int r = 0; r < _totalRows; r++) {
      _grid[r] = newGrid[r];
    }
    return rows.length;
  }

  void reset() {
    for (int r = 0; r < _totalRows; r++) {
      _grid[r] = List.filled(TetrisConstants.boardCols, null);
    }
  }
}
