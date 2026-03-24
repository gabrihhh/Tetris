import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/tetris_game.dart';
import 'game_over_overlay.dart';
import 'pause_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final TetrisGame _game;

  @override
  void initState() {
    super.initState();
    _game = TetrisGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget<TetrisGame>(
            game: _game,
            overlayBuilderMap: {
              'pause': (context, game) => PauseOverlay(game: game),
              'gameOver': (context, game) => GameOverOverlay(game: game),
            },
          ),
          // Botão de pause no canto superior esquerdo
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: _game.onPause,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
