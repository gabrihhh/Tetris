# PATTERNS.md — Code Patterns & Conventions

## Touch Controls

Sem botões. Toda a jogabilidade é controlada por gestos na tela inteira.

| Gesto | Ação |
|---|---|
| Tap | Girar peça (clockwise) |
| Arrastar esquerda | Mover 1 coluna à esquerda |
| Arrastar direita | Mover 1 coluna à direita |
| Arrastar para baixo (segurar) | Soft drop — desce rápido enquanto o dedo está pressionado |
| Swipe rápido para cima (flick) | Hard drop — desce instantaneamente |

### Regras de detecção de gesto

- **Tap vs arraste:** se o delta total do movimento for menor que o threshold (`20px`), é tap. Caso contrário, é arraste.
- **Soft drop:** ativado enquanto `onDragUpdate` detecta movimento contínuo para baixo (`delta.y > 0`). Desativado ao soltar o dedo (`onDragEnd`).
- **Hard drop vs soft drop:** diferenciados pela velocidade do swipe. Se `velocity.y` na direção para cima ultrapassar o threshold de flick (`-800px/s`), é hard drop. Arrastar para baixo devagar é soft drop.
- **Direção dominante:** em arrastes diagonais, o eixo com maior delta determina a ação (horizontal = mover, vertical = soft/hard drop).

## General Guidelines

- Document patterns and conventions here as they are established
- Include naming conventions, folder structure, state management approach, etc.
