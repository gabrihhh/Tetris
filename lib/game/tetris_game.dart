import 'package:flame/game.dart';
import '../components/board_component.dart';
import '../components/input_handler.dart';
import '../components/next_piece_panel.dart';
import '../components/piece_component.dart';
import '../components/score_panel.dart';
import '../logic/board.dart';
import '../logic/piece_controller.dart';
import '../logic/score_manager.dart';
import '../logic/tetrimino.dart';
import '../logic/tetrimino_bag.dart';
import 'constants.dart';
import 'game_state.dart';

class TetrisGame extends FlameGame {
  // Logic layer
  late final Board board;
  late final TetriminoBag bag;
  late final PieceController pieceController;
  late final ScoreManager scoreManager;

  // Components (kept for repositioning on resize)
  late final BoardComponent boardComponent;
  late final PieceComponent pieceComponent;
  late final GhostPieceComponent ghostComponent;
  late final NextPiecePanel nextPiecePanel;
  late final ScorePanel scorePanel;

  GamePhase phase = GamePhase.idle;
  bool isSoftDropping = false;

  double _tickAccumulator = 0;

  @override
  Future<void> onLoad() async {
    board = Board();
    bag = TetriminoBag();
    scoreManager = ScoreManager();
    pieceController = PieceController(board: board);

    boardComponent = BoardComponent(board: board);
    pieceComponent = PieceComponent(controller: pieceController);
    ghostComponent = GhostPieceComponent(controller: pieceController);
    nextPiecePanel = NextPiecePanel(bag: bag);
    scorePanel = ScorePanel(scoreManager: scoreManager);

    await addAll([
      boardComponent,
      ghostComponent,
      pieceComponent,
      nextPiecePanel,
      scorePanel,
      InputHandler(),
    ]);

    _layoutComponents();
    _spawnNextPiece();
    phase = GamePhase.playing;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _layoutComponents();
  }

  void _layoutComponents() {
    final cs = TetrisConstants.cellSize(size.x, size.y);

    final boardWidth = TetrisConstants.boardCols * cs;
    final boardHeight = TetrisConstants.boardRows * cs;
    final panelSize = TetrisConstants.panelCells * cs;
    final panelGap = TetrisConstants.panelGap;

    final totalWidth = boardWidth + panelGap + panelSize;
    final startX = (size.x - totalWidth) / 2;
    final startY = (size.y - boardHeight) / 2;

    boardComponent.cellSize = cs;
    pieceComponent.cellSize = cs;
    ghostComponent.cellSize = cs;
    nextPiecePanel.cellSize = cs;

    boardComponent.position = Vector2(startX, startY);
    pieceComponent.position = Vector2(startX, startY);
    ghostComponent.position = Vector2(startX, startY);

    final panelX = startX + boardWidth + panelGap;
    final nextPanelY = startY + (boardHeight - panelSize) / 2 - 60;
    nextPiecePanel.position = Vector2(panelX, nextPanelY);
    scorePanel.position = Vector2(panelX, nextPanelY + panelSize + 16);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (phase != GamePhase.playing) return;

    final tickRate = isSoftDropping
        ? scoreManager.currentTickRate /
            TetrisConstants.softDropMultiplier
        : scoreManager.currentTickRate;

    _tickAccumulator += dt;
    while (_tickAccumulator >= tickRate) {
      _tickAccumulator -= tickRate;
      final moved = pieceController.moveDown();
      if (isSoftDropping && moved) scoreManager.onSoftDrop(1);
    }

    if (pieceController.update(dt)) {
      _lockCurrentPiece();
    }
  }

  void _lockCurrentPiece() {
    board.lockPiece(pieceController.absoluteCells, pieceController.currentPiece.type);
    final fullRows = board.findFullRows();
    if (fullRows.isNotEmpty) {
      scoreManager.onLinesCleared(board.clearRows(fullRows));
    }
    _tickAccumulator = 0;
    _spawnNextPiece();
  }

  void _spawnNextPiece() {
    final next = Tetrimino.fromType(bag.next());
    pieceController.spawn(next);

    if (!board.isValidPosition(pieceController.absoluteCells)) {
      phase = GamePhase.gameOver;
      overlays.add('gameOver');
    }
  }

  // ── Input callbacks ───────────────────────────────────────────
  void onMoveLeft() {
    if (phase == GamePhase.playing) pieceController.moveLeft();
  }

  void onMoveRight() {
    if (phase == GamePhase.playing) pieceController.moveRight();
  }

  void onRotate() {
    if (phase == GamePhase.playing) pieceController.rotateClockwise();
  }

  void onHardDrop() {
    if (phase != GamePhase.playing) return;
    final rows = pieceController.hardDrop();
    scoreManager.onHardDrop(rows);
    _lockCurrentPiece();
  }

  void onSoftDropStart() {
    if (phase == GamePhase.playing) isSoftDropping = true;
  }

  void onSoftDropEnd() => isSoftDropping = false;

  void onPause() {
    if (phase == GamePhase.playing) {
      phase = GamePhase.paused;
      overlays.add('pause');
    }
  }

  void onResume() {
    if (phase == GamePhase.paused) {
      phase = GamePhase.playing;
      overlays.remove('pause');
    }
  }

  void restart() {
    board.reset();
    scoreManager.reset();
    _tickAccumulator = 0;
    isSoftDropping = false;
    overlays.remove('gameOver');
    overlays.remove('pause');
    _spawnNextPiece();
    phase = GamePhase.playing;
  }
}
