import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'tetromino.dart';
import 'game_board.dart';
import 'game_record.dart';
import '../services/database_helper.dart';

enum GameState { playing, paused, gameOver }

class GameLogic extends ChangeNotifier {
  GameBoard board = GameBoard();
  Tetromino? currentPiece;
  Tetromino? nextPiece;
  Tetromino? heldPiece;
  bool canHold = true; // Prevents holding multiple times per piece
  List<Tetromino> nextPieces = [];
  
  GameState gameState = GameState.paused;
  Timer? gameTimer;
  Timer? autoSaveTimer;
  
  // Game statistics
  int score = 0;
  int level = 1;
  int linesCleared = 0;
  int totalLines = 0;
  
  // Game settings
  int baseDropTime = 1000; // ms
  int currentDropTime = 1000;
  
  // Game timing
  DateTime? gameStartTime;
  int gameDuration = 0; // in seconds
  
  // Database
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  GameRecord? personalBest;
  
  GameLogic() {
    _initializeGame();
    _loadPersonalBest();
    _startAutoSave();
  }

  void _initializeGame() {
    board.reset();
    score = 0;
    level = 1;
    linesCleared = 0;
    totalLines = 0;
    currentDropTime = baseDropTime;
    gameStartTime = DateTime.now();
    gameDuration = 0;
    heldPiece = null;
    canHold = true;
    
    // Generate next pieces
    nextPieces.clear();
    for (int i = 0; i < 3; i++) {
      nextPieces.add(Tetromino.random());
    }
    
    _spawnNewPiece();
    notifyListeners();
  }

  Future<void> _loadPersonalBest() async {
    personalBest = await _dbHelper.getPersonalBest();
    notifyListeners();
  }

  void _spawnNewPiece() {
    currentPiece = nextPieces.removeAt(0);
    nextPieces.add(Tetromino.random());
    canHold = true; // Reset hold ability for new piece
    
    // Check if game is over
    if (currentPiece != null && !board.isValidPosition(currentPiece!)) {
      gameState = GameState.gameOver;
      _stopTimer();
      _saveGameRecord();
    }
    
    notifyListeners();
  }

  Future<void> _saveGameRecord() async {
    if (gameStartTime != null) {
      gameDuration = DateTime.now().difference(gameStartTime!).inSeconds;
    }
    
    final record = GameRecord(
      score: score,
      level: level,
      lines: totalLines,
      date: DateTime.now(),
      duration: gameDuration,
    );
    
    await _dbHelper.insertRecord(record);
    await _loadPersonalBest(); // Reload personal best after saving
  }

  void startGame() {
    _initializeGame();
    gameState = GameState.playing;
    _startTimer();
    notifyListeners();
  }

  void restartGame() {
    _stopTimer();
    _initializeGame();
    gameState = GameState.playing;
    _startTimer();
    notifyListeners();
  }

  void pauseGame() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
      _stopTimer();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (gameState == GameState.paused) {
      gameState = GameState.playing;
      _startTimer();
      notifyListeners();
    }
  }

  void _startTimer() {
    _stopTimer();
    gameTimer = Timer.periodic(Duration(milliseconds: currentDropTime), (timer) {
      _dropPiece();
    });
  }

  void _stopTimer() {
    gameTimer?.cancel();
    gameTimer = null;
  }

  void _dropPiece() {
    if (currentPiece == null || gameState != GameState.playing) return;
    
    if (board.isValidPosition(currentPiece!, newY: currentPiece!.y + 1)) {
      currentPiece = currentPiece!.copyWith(y: currentPiece!.y + 1);
    } else {
      // Piece reached bottom or collided
      board.placeTetromino(currentPiece!);
      _checkLines();
      _spawnNewPiece();
    }
    
    notifyListeners();
  }

  void _checkLines() {
    List<int> completedLines = board.checkLines();
    
    if (completedLines.isNotEmpty) {
      board.clearLines(completedLines);
      
      int lines = completedLines.length;
      linesCleared += lines;
      totalLines += lines;
      
      // Calcula pontuação baseada no número de linhas
      int lineScore = 0;
      switch (lines) {
        case 1:
          lineScore = 40 * level;
          break;
        case 2:
          lineScore = 100 * level;
          break;
        case 3:
          lineScore = 300 * level;
          break;
        case 4:
          lineScore = 1200 * level; // Tetris!
          break;
      }
      
      score += lineScore;
      
      // Increase level every 10 lines
      int newLevel = (totalLines ~/ 10) + 1;
      if (newLevel > level) {
        level = newLevel;
        // Increase speed
        currentDropTime = max(50, baseDropTime - (level - 1) * 50);
        _startTimer(); // Restart timer with new speed
      }
    }
  }

  bool movePiece(int dx, int dy) {
    if (currentPiece == null || gameState != GameState.playing) return false;
    
    if (board.isValidPosition(currentPiece!, 
        newX: currentPiece!.x + dx, 
        newY: currentPiece!.y + dy)) {
      currentPiece = currentPiece!.copyWith(
        x: currentPiece!.x + dx,
        y: currentPiece!.y + dy,
      );
      notifyListeners();
      return true;
    }
    
    return false;
  }

  bool rotatePiece() {
    if (currentPiece == null || gameState != GameState.playing) return false;
    
    int newRotation = (currentPiece!.rotation + 1) % 4;
    
    if (board.isValidPosition(currentPiece!, newRotation: newRotation)) {
      currentPiece = currentPiece!.copyWith(rotation: newRotation);
      notifyListeners();
      return true;
    }
    
    return false;
  }

  void hardDrop() {
    if (currentPiece == null || gameState != GameState.playing) return;
    
    while (board.isValidPosition(currentPiece!, newY: currentPiece!.y + 1)) {
      currentPiece = currentPiece!.copyWith(y: currentPiece!.y + 1);
      score += 2; // Bonus for hard drop
    }
    
    // Place piece immediately
    board.placeTetromino(currentPiece!);
    _checkLines();
    _spawnNewPiece();
    notifyListeners();
  }

  void softDrop() {
    if (movePiece(0, 1)) {
      score += 1; // Bonus for soft drop
    }
  }

  // Hold functionality
  void holdPiece() {
    if (currentPiece == null || gameState != GameState.playing || !canHold) return;
    
    if (heldPiece == null) {
      // First time holding a piece
      heldPiece = currentPiece!.copyWith(x: 0, y: 0, rotation: 0);
      _spawnNewPiece();
    } else {
      // Swap current piece with held piece
      Tetromino temp = currentPiece!.copyWith(x: 0, y: 0, rotation: 0);
      currentPiece = heldPiece!.copyWith(x: 4, y: 0, rotation: 0);
      heldPiece = temp;
      
      // Check if swapped piece is valid, if not game over
      if (!board.isValidPosition(currentPiece!)) {
        gameState = GameState.gameOver;
        _stopTimer();
        _saveGameRecord();
      }
    }
    
    canHold = false; // Prevent holding again until next piece
    notifyListeners();
  }

  // Auto-save functionality
  void _startAutoSave() {
    autoSaveTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _autoSaveProgress();
    });
  }

  void _autoSaveProgress() async {
    if (gameState == GameState.playing && score > 0) {
      try {
        final record = GameRecord(
          score: score,
          level: level,
          lines: totalLines,
          date: DateTime.now(),
          duration: currentGameDuration,
        );
        
        await _dbHelper.insertRecord(record);
        await _loadPersonalBest(); // Update personal best if needed
      } catch (e) {
        print('Auto-save failed: $e');
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    autoSaveTimer?.cancel();
    super.dispose();
  }

    
  // Getter for the board with current piece
  List<List<Map<String, dynamic>>> get boardDisplay {
    return board.getBoardWithPiece(currentPiece);
  }

  // Getter to check if game is running
  bool get isPlaying => gameState == GameState.playing;
  bool get isPaused => gameState == GameState.paused;
  bool get isGameOver => gameState == GameState.gameOver;

  // Get top records from database
  Future<List<GameRecord>> getTopRecords([int limit = 10]) async {
    return await _dbHelper.getTopRecords(limit);
  }

  // Get game statistics
  Future<Map<String, dynamic>> getGameStats() async {
    return await _dbHelper.getGameStats();
  }

  // Get current game duration
  int get currentGameDuration {
    if (gameStartTime != null) {
      return DateTime.now().difference(gameStartTime!).inSeconds;
    }
    return 0;
  }

  // Check if current score is a new personal best
  bool get isNewPersonalBest {
    return personalBest == null || score > personalBest!.score;
  }

  // Getter for held piece
  Tetromino? get getHeldPiece => heldPiece;
  
  // Getter for can hold status
  bool get getCanHold => canHold;
}