import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../game/constants.dart';
import '../game/tetris_game.dart';

class InputHandler extends PositionComponent
    with DragCallbacks, HasGameReference<TetrisGame> {
  // Primary pointer: handles drag gestures (move, soft drop, hard drop).
  // Any additional pointer triggers rotation (second finger = rotate).
  int? _primaryPointerId;
  final Set<int> _activePointers = {};
  bool _rotatedThisGesture = false;

  Vector2? _dragStart;
  double _dragStartTime = 0;
  Vector2 _currentDragPos = Vector2.zero();
  bool _isSoftDropping = false;
  bool _dragConsumed = false;

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void onDragStart(DragStartEvent event) {
    _activePointers.add(event.pointerId);

    if (_primaryPointerId == null) {
      // First finger: start drag tracking
      _primaryPointerId = event.pointerId;
      _dragStart = event.localPosition.clone();
      _currentDragPos = event.localPosition.clone();
      _dragStartTime = DateTime.now().millisecondsSinceEpoch.toDouble();
      _isSoftDropping = false;
      _dragConsumed = false;
      _rotatedThisGesture = false;
    } else if (!_rotatedThisGesture) {
      // Second finger: rotate once per multi-touch gesture
      _rotatedThisGesture = true;
      if (_isSoftDropping) {
        game.onSoftDropEnd();
        _isSoftDropping = false;
      }
      _dragStart = null; // discard single-finger drag to avoid ghost swipe
      if (game.phase.name == 'playing') game.onRotate();
    }

    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Only track updates from the primary finger
    if (event.pointerId != _primaryPointerId || _dragStart == null) {
      super.onDragUpdate(event);
      return;
    }

    _currentDragPos += event.localDelta;

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
    _activePointers.remove(event.pointerId);

    if (event.pointerId == _primaryPointerId) {
      if (_isSoftDropping) {
        game.onSoftDropEnd();
        _isSoftDropping = false;
      }

      if (_dragStart != null && !_dragConsumed) {
        final delta = _currentDragPos - _dragStart!;
        final elapsed =
            (DateTime.now().millisecondsSinceEpoch.toDouble() - _dragStartTime) /
                1000.0;
        final velocityY = elapsed > 0 ? delta.y / elapsed : 0.0;

        final absX = delta.x.abs();
        final absY = delta.y.abs();

        if (absX > absY && absX > TetrisConstants.swipeThreshold) {
          if (delta.x < 0) game.onMoveLeft();
          else game.onMoveRight();
        } else if (absY > absX && delta.y < -TetrisConstants.swipeThreshold) {
          if (velocityY.abs() >= TetrisConstants.hardDropVelocityThreshold) {
            game.onHardDrop();
          }
        }
      }

      _primaryPointerId = null;
      _dragStart = null;
    }

    if (_activePointers.isEmpty) {
      _rotatedThisGesture = false;
    }

    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _activePointers.remove(event.pointerId);

    if (event.pointerId == _primaryPointerId) {
      if (_isSoftDropping) {
        game.onSoftDropEnd();
        _isSoftDropping = false;
      }
      _primaryPointerId = null;
      _dragStart = null;
    }

    if (_activePointers.isEmpty) {
      _rotatedThisGesture = false;
    }

    super.onDragCancel(event);
  }
}
