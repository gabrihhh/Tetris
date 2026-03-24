# PROJECT.md — What's in the Project

## Current State

Jogo implementado e compilando sem erros. Pronto para rodar em dispositivo/emulador Android.

## What Exists

| Item | Status |
|------|--------|
| Flutter project scaffold | Done |
| Flame dependency (`^1.36.0`) | Done |
| Game board (grid 10×20) | Done |
| Pieces (7 tetrominoes + rotações SRS) | Done |
| 7-bag randomizer | Done |
| Game loop (tick acumulador) | Done |
| Collision detection | Done |
| Lock delay (0.5s, max 15 resets) | Done |
| Line clearing | Done |
| Ghost piece | Done |
| Next piece panel | Done |
| Score / level / lines HUD | Done |
| Touch controls (tap/swipe) | Done |
| Game over overlay | Done |
| Pause overlay | Done |

## Planned Structure

```
lib/
├── main.dart
├── app.dart
│
├── game/
│   ├── tetris_game.dart       # FlameGame root — central orchestrator
│   ├── game_state.dart        # Enum: idle, playing, paused, gameOver
│   └── constants.dart         # Grid size, tick rates, colors, scoring
│
├── logic/                     # Pure Dart — zero Flutter/Flame imports
│   ├── board.dart             # Grid state, line clearing, collision detection
│   ├── tetrimino.dart         # 7 piece shapes, rotations (SRS), colors
│   ├── tetrimino_bag.dart     # 7-bag randomizer
│   ├── piece_controller.dart  # Active piece: movement, lock delay, ghost
│   └── score_manager.dart     # Score, level, lines cleared
│
├── components/                # Flame rendering components
│   ├── board_component.dart   # Renders 10x20 grid + locked cells
│   ├── piece_component.dart   # Renders the falling piece
│   ├── ghost_piece_component.dart # Drop preview (30% opacity)
│   ├── next_piece_panel.dart  # Right panel — next piece preview
│   ├── score_panel.dart       # Score / level / lines HUD
│   └── input_handler.dart     # Touch gestures + keyboard
│
└── ui/
    ├── game_screen.dart       # Flutter widget hosting the Flame GameWidget
    ├── pause_overlay.dart     # Pause menu
    └── game_over_overlay.dart # Game over screen
```

## Board

- **10 columns × 20 visible rows** (+ 2 hidden rows at top as spawn buffer)
- Grid centered on screen, black background

## Right Panel (vertically centered)

- Next piece preview (4×4 cell box)
- Score, level, and lines counter below

## How to Play

| Gesto | Ação |
|---|---|
| Tap | Girar peça |
| Arrastar esquerda/direita | Mover coluna |
| Arrastar para baixo (segurar) | Soft drop |
| Swipe rápido para cima | Hard drop |

## Current Flow

1. Peça spawna nas 2 linhas ocultas do topo, centralizada
2. Cai automaticamente conforme o tick rate do nível atual
3. Player controla via gestos
4. Ao encostar no fundo ou em outra peça → lock delay de 0.5s
5. Após o lock → verifica linhas completas → limpa → pontua → spawna próxima peça
6. Se o spawn colidir imediatamente → Game Over

## How to Run

```bash
flutter pub get
flutter run         # Android or iOS device/emulator
```
