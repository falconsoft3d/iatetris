import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_logic.dart';
import '../models/tetromino.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/next_piece_widget.dart';
import '../widgets/game_info_widget.dart';
import 'records_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    gameLogic.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        gameLogic.movePiece(-1, 0);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        gameLogic.movePiece(1, 0);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        gameLogic.softDrop();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                 event.logicalKey == LogicalKeyboardKey.space) {
        gameLogic.rotatePiece();
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        gameLogic.hardDrop();
      } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        gameLogic.holdPiece(); // Hold piece with C key
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        if (gameLogic.isPlaying) {
          gameLogic.pauseGame();
        } else if (gameLogic.isPaused) {
          gameLogic.resumeGame();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        gameLogic.restartGame();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: AnimatedBuilder(
          animation: gameLogic,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Color(0xFF16213e),
                    Color(0xFF0f3460),
                    Color(0xFF533483),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left area - Information
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Pause/Play button
                              _buildControlButton(),
                              SizedBox(height: 20),
                              // Records button
                              _buildRecordsButton(),
                              SizedBox(height: 20),
                              // Hold (reserved next piece)
                              _buildHoldArea(),
                              SizedBox(height: 20),
                              // Game information
                              GameInfoWidget(gameLogic: gameLogic),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 20),
                      
                      // Central area - Game board
                      Expanded(
                        flex: 4,
                        child: GameBoardWidget(gameLogic: gameLogic),
                      ),
                      
                      SizedBox(width: 20),
                      
                      // Right area - Next pieces
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              NextPieceWidget(gameLogic: gameLogic),
                              SizedBox(height: 20),
                              _buildGameOverlay(),
                              SizedBox(height: 20),
                              _buildAuthorInfo(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: () {
          if (gameLogic.isPlaying) {
            gameLogic.pauseGame();
          } else if (gameLogic.isPaused) {
            gameLogic.resumeGame();
          } else {
            gameLogic.startGame();
          }
        },
        icon: Icon(
          gameLogic.isPlaying 
            ? Icons.pause 
            : gameLogic.isGameOver 
              ? Icons.refresh 
              : Icons.play_arrow,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildRecordsButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordsScreen(gameLogic: gameLogic),
            ),
          );
        },
        icon: Icon(
          Icons.leaderboard,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildHoldArea() {
    return GestureDetector(
      onTap: () => gameLogic.holdPiece(),
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: gameLogic.getCanHold 
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gameLogic.getCanHold 
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2)
          ),
        ),
        child: Column(
          children: [
            Text(
              'Hold (C)',
              style: TextStyle(
                color: gameLogic.getCanHold 
                    ? Colors.white 
                    : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: gameLogic.getHeldPiece != null
                    ? _buildHeldPieceDisplay(gameLogic.getHeldPiece!)
                    : Center(
                        child: Text(
                          'Empty',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeldPieceDisplay(Tetromino piece) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: piece.shape.asMap().entries.map((rowEntry) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowEntry.value.asMap().entries.map((colEntry) {
                bool isBlock = colEntry.value == 1;
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: isBlock ? piece.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGameOverlay() {
    if (gameLogic.isGameOver) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Press R to restart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (gameLogic.isPaused) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Press P to continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              'C to Hold piece',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Container();
  }

  Widget _buildAuthorInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person,
            color: Colors.white.withOpacity(0.8),
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            'Autor:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Marlon Falcon Hdez',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Web:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'www.marlonfalcon.com',
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}