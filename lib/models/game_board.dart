import 'dart:math';
import 'tetromino.dart';

class GameBoard {
  static const int width = 10;
  static const int height = 20;
  late List<List<int>> board;
  late List<List<int>> colors; // To store piece colors

  GameBoard() {
    _initializeBoard();
  }

  void _initializeBoard() {
    board = List.generate(height, (i) => List.filled(width, 0));
    colors = List.generate(height, (i) => List.filled(width, 0));
  }

  bool isValidPosition(Tetromino tetromino, {int? newX, int? newY, int? newRotation}) {
    int x = newX ?? tetromino.x;
    int y = newY ?? tetromino.y;
    int rotation = newRotation ?? tetromino.rotation;
    
    List<List<int>> shape = tetromino.getRotatedShape(rotation);
    
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          int newX = x + j;
          int newY = y + i;
          
          // Check bounds
          if (newX < 0 || newX >= width || newY >= height) {
            return false;
          }
          
          // Check collision with placed pieces
          if (newY >= 0 && board[newY][newX] == 1) {
            return false;
          }
        }
      }
    }
    
    return true;
  }

  void placeTetromino(Tetromino tetromino) {
    List<Point<int>> blocks = tetromino.getBlocks();
    
    for (Point<int> block in blocks) {
      if (block.y >= 0) {
        board[block.y][block.x] = 1;
        colors[block.y][block.x] = _getColorValue(tetromino.color);
      }
    }
  }

  int _getColorValue(dynamic color) {
    // Returns a numeric value to represent the color
    return color.hashCode;
  }

  List<int> checkLines() {
    List<int> completedLines = [];
    
    for (int i = height - 1; i >= 0; i--) {
      if (board[i].every((cell) => cell == 1)) {
        completedLines.add(i);
      }
    }
    
    return completedLines;
  }

  void clearLines(List<int> lines) {
    for (int line in lines.reversed) {
      board.removeAt(line);
      colors.removeAt(line);
      board.insert(0, List.filled(width, 0));
      colors.insert(0, List.filled(width, 0));
    }
  }

  bool isGameOver() {
    // Check if there are pieces in the top row
    return board[0].any((cell) => cell == 1);
  }

  void reset() {
    _initializeBoard();
  }

  // Method to get a view of the board with the current piece
  List<List<Map<String, dynamic>>> getBoardWithPiece(Tetromino? currentPiece) {
    List<List<Map<String, dynamic>>> visualBoard = List.generate(
      height,
      (i) => List.generate(
        width,
        (j) => {
          'filled': board[i][j] == 1,
          'color': board[i][j] == 1 ? colors[i][j] : 0,
          'isCurrentPiece': false,
        },
      ),
    );

    if (currentPiece != null) {
      List<Point<int>> blocks = currentPiece.getBlocks();
      for (Point<int> block in blocks) {
        if (block.y >= 0 && block.y < height && block.x >= 0 && block.x < width) {
          visualBoard[block.y][block.x] = {
            'filled': true,
            'color': _getColorValue(currentPiece.color),
            'isCurrentPiece': true,
          };
        }
      }
    }

    return visualBoard;
  }
}