# FEATURES.md — Planned Features

## MVP (v1.0 — Android)

| # | Feature | Description | Priority | Status |
|---|---------|-------------|----------|--------|
| 1 | Game board | 10x20 grid, black background, centered on screen | High | Pending |
| 2 | Tetriminos (7 pieces) | I, O, T, S, Z, J, L — with colors and 4 rotations each | High | Pending |
| 3 | Piece spawning | 7-bag randomizer (no long droughts) | High | Pending |
| 4 | Gravity / game loop | Tick-based falling speed, increases with level | High | Pending |
| 5 | Collision detection | Walls, floor, and locked pieces | High | Pending |
| 6 | Piece locking | Lock delay (0.5s), max 15 lock resets | High | Pending |
| 7 | Line clearing | Clear full rows, drop everything above | High | Pending |
| 8 | Next piece panel | Right side, vertically centered, shows upcoming piece | High | Pending |
| 9 | Score system | 1 line=100, 2=300, 3=500, 4=800 (×level) | High | Pending |
| 10 | Level progression | Level up every 10 lines, speed increases | High | Pending |
| 11 | Touch controls | Swipe left/right = move, tap = rotate, swipe down = soft drop, swipe up = hard drop | High | Pending |
| 12 | Ghost piece | Preview of where piece will land (semi-transparent) | Medium | Pending |
| 13 | Game over screen | Overlay with score and restart button | High | Pending |
| 14 | Pause screen | Overlay with resume button | Medium | Pending |

## Post-MVP

| # | Feature | Description | Priority | Status |
|---|---------|-------------|----------|--------|
| 15 | Tela inicial | Título "TETRIS" centralizado no topo, botão "NEW GAME" e exibição do best record abaixo | High | Backlog |
| 16 | Best record local | Salvar a maior pontuação no dispositivo (SharedPreferences) e exibir na tela inicial e na tela de game over | High | Backlog |
| 17 | Pontuação na tela de game over | Mostrar score atual vs best record, destacar quando bater recorde | High | Backlog |
| 18 | Hold piece | Store a piece and swap it once per turn | Medium | Backlog |
| 19 | Sound effects | Line clear, piece lock, level up, game over | Medium | Backlog |
| 20 | Animations | Line clear flash, piece lock effect | Low | Backlog |
| 21 | iOS port | Deploy to Apple App Store | High | Backlog |
