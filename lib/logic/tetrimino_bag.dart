import 'dart:collection';
import 'dart:math';
import 'tetrimino.dart';

class TetriminoBag {
  final Queue<TetriminoType> _queue = Queue();
  final Random _random = Random();

  TetriminoType next() {
    if (_queue.isEmpty) _refill();
    return _queue.removeFirst();
  }

  TetriminoType peek() {
    if (_queue.isEmpty) _refill();
    return _queue.first;
  }

  void _refill() {
    final bag = TetriminoType.values.toList()..shuffle(_random);
    _queue.addAll(bag);
  }
}
