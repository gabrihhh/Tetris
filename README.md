# Tetris

A Tetris game built with Flutter + Flame, targeting Android (primary) and iOS (planned).

## Gameplay

| Gesture | Action |
|---|---|
| Tap | Rotate piece |
| Swipe left / right | Move piece |
| Hold swipe down | Soft drop |
| Quick swipe up | Hard drop |

## Features

- 7 official Tetriminos (I, O, T, S, Z, J, L) with SRS rotation system
- 7-bag randomizer — no long droughts of any piece
- Ghost piece showing where the piece will land
- Next piece preview panel
- Score system (100 / 300 / 500 / 800 × level)
- Level progression every 10 lines with increasing speed
- Best score saved locally on device
- Home screen with best record display
- Pause menu with resume, restart and quit options

## Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Game engine | Flame |
| Language | Dart |
| Local storage | shared_preferences |

## Project Structure

```
lib/
├── main.dart
├── game/
│   ├── tetris_game.dart       # FlameGame root — game loop orchestrator
│   ├── game_state.dart        # GamePhase enum
│   └── constants.dart         # Grid size, tick rates, colors, thresholds
├── logic/                     # Pure Dart — no Flutter/Flame dependencies
│   ├── board.dart             # Grid state, collision detection, line clearing
│   ├── tetrimino.dart         # 7 piece shapes with 4 rotations each (SRS)
│   ├── tetrimino_bag.dart     # 7-bag randomizer
│   ├── piece_controller.dart  # Active piece: movement, lock delay, ghost
│   └── score_manager.dart     # Score, level, speed progression
├── components/                # Flame rendering components
│   ├── board_component.dart
│   ├── piece_component.dart
│   ├── next_piece_panel.dart
│   ├── score_panel.dart
│   └── input_handler.dart     # Touch gesture detection
├── ui/                        # Flutter screens and overlays
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── pause_overlay.dart
│   └── game_over_overlay.dart
└── services/
    └── score_storage.dart     # SharedPreferences wrapper
```

## Running

```bash
# Install dependencies
flutter pub get

# Run on connected Android device
flutter run

# Build release APK
flutter build apk --release
```

## Documentation

Full project documentation is in the [`docs/`](docs/) folder:

- [`docs/INDEX.md`](docs/INDEX.md) — Project overview
- [`docs/STACK.md`](docs/STACK.md) — Stack decisions
- [`docs/PATTERNS.md`](docs/PATTERNS.md) — Code patterns and touch controls
- [`docs/PROJECT.md`](docs/PROJECT.md) — Current state and flow
- [`docs/FEATURES.md`](docs/FEATURES.md) — Roadmap
- [`docs/BUGS.md`](docs/BUGS.md) — Known issues
