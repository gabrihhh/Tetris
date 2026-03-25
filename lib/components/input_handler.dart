import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../game/constants.dart';
import '../game/tetris_game.dart';

class InputHandler extends PositionComponent
    with TapCallbacks, DragCallbacks, HasGameReference<TetrisGame> {
  Vector2? _dragStart;
  double _dragStartTime = 0;
  Vector2 _currentDragPos = Vector2.zero();
  bool _isSoftDropping = false;
  bool _dragConsumed = false;

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  // ── Tap = rotate ──────────────────────────────────────────────
  // Fallback: fires only when onDragEnd didn't already handle the event.
  // We set _dragConsumed = true so that if onDragEnd fires afterwards
  // (Flame event order is not guaranteed) it won't double-rotate.
  @override
  void onTapUp(TapUpEvent event) {
    if (!_dragConsumed) {
      game.onRotate();
      _dragConsumed = true;
    }
    super.onTapUp(event);
  }

  // ── Drag ──────────────────────────────────────────────────────
  @override
  void onDragStart(DragStartEvent event) {
    _dragStart = event.localPosition.clone();
    _currentDragPos = event.localPosition.clone();
    _dragStartTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    _isSoftDropping = false;
    _dragConsumed = false;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _currentDragPos += event.localDelta;

    if (_dragStart == null) {
      super.onDragUpdate(event);
      return;
    }

    final delta = _currentDragPos - _dragStart!;
    final movingDown = delta.y > TetrisConstants.swipeThreshold;

    if (movingDown && !_isSoftDropping) {
      _isSoftDropping = true;
      _dragConsumed = true;
      game.onSoftDropStart();
    } else if (!movingDown && _isSoftDropping) {
      _isSoftDropping = false;
      game.onSoftDropEnd();
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_isSoftDropping) {
      game.onSoftDropEnd();
      _isSoftDropping = false;
    }

    if (_dragStart != null) {
      final delta = _currentDragPos - _dragStart!;
      final elapsed =
          (DateTime.now().millisecondsSinceEpoch.toDouble() - _dragStartTime) /
              1000.0;
      final velocityY = elapsed > 0 ? delta.y / elapsed : 0.0;

      final absX = delta.x.abs();
      final absY = delta.y.abs();

      if (absX > absY && absX > TetrisConstants.swipeThreshold) {
        _dragConsumed = true;
        if (delta.x < 0) {
          game.onMoveLeft();
        } else {
          game.onMoveRight();
        }
      } else if (absY > absX && delta.y < -TetrisConstants.swipeThreshold) {
        if (velocityY.abs() >= TetrisConstants.hardDropVelocityThreshold) {
          _dragConsumed = true;
          game.onHardDrop();
        }
      }

      // If no gesture was consumed, treat it as a tap → rotate.
      // This is more reliable than onTapUp alone because Flame sometimes
      // skips onTapUp when the finger moves slightly during a tap.
      if (!_dragConsumed) {
        _dragConsumed = true; // prevent onTapUp from double-rotating
        game.onRotate();
      }
    }

    _dragStart = null;
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    if (_isSoftDropping) {
      game.onSoftDropEnd();
      _isSoftDropping = false;
    }
    _dragStart = null;
    super.onDragCancel(event);
  }
}
