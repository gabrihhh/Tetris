import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const _key = 'best_score';

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<bool> saveBestScore(int score) async {
    final current = await getBestScore();
    if (score > current) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, score);
      return true; // novo recorde
    }
    return false;
  }
}
