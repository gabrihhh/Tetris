import 'package:flutter/material.dart';
import '../game/tetris_game.dart';
import '../services/score_storage.dart';

class GameOverOverlay extends StatefulWidget {
  final TetrisGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  int _bestScore = 0;
  bool _isNewRecord = false;

  @override
  void initState() {
    super.initState();
    _handleScore();
  }

  Future<void> _handleScore() async {
    final isNew = await ScoreStorage.saveBestScore(widget.game.scoreManager.score);
    final best = await ScoreStorage.getBestScore();
    setState(() {
      _bestScore = best;
      _isNewRecord = isNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.game.scoreManager.score;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        decoration: BoxDecoration(
          color: const Color(0xEE111111),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 24),

            // Score atual
            Text(
              'SCORE',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (_isNewRecord) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.6)),
                ),
                child: const Text(
                  'NEW RECORD!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                'BEST  $_bestScore',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Botões
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button(
                  label: 'MENU',
                  onTap: () => Navigator.of(context).pop(),
                  outlined: true,
                ),
                const SizedBox(width: 12),
                _button(
                  label: 'AGAIN',
                  onTap: widget.game.restart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required String label,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return SizedBox(
      width: 100,
      height: 44,
      child: outlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
    );
  }
}
