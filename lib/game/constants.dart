import 'package:flutter/material.dart';

class TetrisConstants {
  // Board
  static const int boardCols = 10;
  static const int boardRows = 20;
  static const int hiddenRows = 2;

  // Side panel width as fraction of cell size
  static const double panelCells = 5.0; // panel width = 5 cells
  static const double panelGap = 12.0;
  static const double screenPadding = 16.0;

  /// Calculates the cell size that fits the board on screen.
  static double cellSize(double screenWidth, double screenHeight) {
    // Height constraint: board must fit vertically with padding
    final maxByHeight =
        (screenHeight - screenPadding * 2) / boardRows;
    // Width constraint: board + gap + panel must fit horizontally
    final maxByWidth =
        (screenWidth - screenPadding * 2 - panelGap) /
            (boardCols + panelCells);
    return maxByHeight < maxByWidth ? maxByHeight : maxByWidth;
  }

  // Tick
  static const double baseTickRate = 0.8;
  static const double softDropMultiplier = 8.0;

  // Lock delay
  static const double lockDelaySeconds = 0.5;
  static const int maxLockResets = 15;

  // Scoring
  static const Map<int, int> lineScoreBase = {
    1: 100,
    2: 300,
    3: 500,
    4: 800,
  };

  // Input
  static const double swipeThreshold = 45.0;
  static const double hardDropVelocityThreshold = 1000.0;

  // Colors
  static const Color background = Colors.black;
  static const Color gridLine = Color(0xFF1A1A1A);
  static const Color ghostColor = Color(0x44FFFFFF);

  static const Map<String, Color> pieceColors = {
    'I': Color(0xFF00FFFF), // cyan
    'O': Color(0xFFFFFF00), // yellow
    'T': Color(0xFFAA00FF), // purple
    'S': Color(0xFF00FF00), // green
    'Z': Color(0xFFFF0000), // red
    'J': Color(0xFF0000FF), // blue
    'L': Color(0xFFFF8000), // orange
  };
}
