import '../game/constants.dart';

class ScoreManager {
  int score = 0;
  int level = 1;
  int totalLinesCleared = 0;

  void onLinesCleared(int lines) {
    final base = TetrisConstants.lineScoreBase[lines] ?? 0;
    score += base * level;
    totalLinesCleared += lines;
    level = (totalLinesCleared ~/ 10) + 1;
  }

  void onHardDrop(int rowsDropped) {
    score += rowsDropped * 2;
  }

  void onSoftDrop(int rowsDropped) {
    score += rowsDropped;
  }

  double get currentTickRate {
    final rate = TetrisConstants.baseTickRate * pow(0.85, level - 1);
    return rate.clamp(0.05, TetrisConstants.baseTickRate);
  }

  void reset() {
    score = 0;
    level = 1;
    totalLinesCleared = 0;
  }
}

double pow(double base, int exp) {
  double result = 1.0;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}
