# STACK.md — Tech Stack

## Platform Targets

| Platform | Status     |
|----------|------------|
| Android  | Primary    |
| iOS      | Planned    |

## Core Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Framework | [Flutter](https://flutter.dev) | Single codebase for Android + iOS |
| Game Engine | [Flame](https://flame-engine.org) | 2D game engine on top of Flutter — handles game loop, rendering, input |
| Language | Dart | |

## Why Flutter + Flame

- One codebase covers Android (primary) and iOS (planned)
- Flame provides game loop, component system, and collision detection out of the box
- Flutter handles menus, UI, and non-game screens natively
- Strong mobile community and active Flame ecosystem
