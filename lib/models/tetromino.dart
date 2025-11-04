import 'dart:math';
import 'package:flutter/material.dart';

enum TetrominoType { I, O, T, S, Z, J, L }

class Tetromino {
  TetrominoType type;
  List<List<int>> shape;
  Color color;
  int x;
  int y;
  int rotation;

  Tetromino({
    required this.type,
    required this.shape,
    required this.color,
    this.x = 3,
    this.y = 0,
    this.rotation = 0,
  });

  static Tetromino random() {
    final types = TetrominoType.values;
    final type = types[Random().nextInt(types.length)];
    return createTetromino(type);
  }

  static Tetromino createTetromino(TetrominoType type) {
    switch (type) {
      case TetrominoType.I:
        return Tetromino(
          type: type,
          shape: [[1, 1, 1, 1]],
          color: Colors.cyan,
        );
      case TetrominoType.O:
        return Tetromino(
          type: type,
          shape: [
            [1, 1],
            [1, 1]
          ],
          color: Colors.yellow,
        );
      case TetrominoType.T:
        return Tetromino(
          type: type,
          shape: [
            [0, 1, 0],
            [1, 1, 1]
          ],
          color: Colors.purple,
        );
      case TetrominoType.S:
        return Tetromino(
          type: type,
          shape: [
            [0, 1, 1],
            [1, 1, 0]
          ],
          color: Colors.green,
        );
      case TetrominoType.Z:
        return Tetromino(
          type: type,
          shape: [
            [1, 1, 0],
            [0, 1, 1]
          ],
          color: Colors.red,
        );
      case TetrominoType.J:
        return Tetromino(
          type: type,
          shape: [
            [1, 0, 0],
            [1, 1, 1]
          ],
          color: Colors.blue,
        );
      case TetrominoType.L:
        return Tetromino(
          type: type,
          shape: [
            [0, 0, 1],
            [1, 1, 1]
          ],
          color: Colors.orange,
        );
    }
  }

  Tetromino copyWith({int? x, int? y, int? rotation, List<List<int>>? shape}) {
    return Tetromino(
      type: type,
      shape: shape ?? this.shape,
      color: color,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
    );
  }

  List<List<int>> getRotatedShape(int rotation) {
    List<List<int>> rotatedShape = shape;
    
    for (int i = 0; i < rotation % 4; i++) {
      rotatedShape = _rotateMatrix(rotatedShape);
    }
    
    return rotatedShape;
  }

  List<List<int>> _rotateMatrix(List<List<int>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;
    
    List<List<int>> rotated = List.generate(
      cols,
      (i) => List.generate(rows, (j) => 0),
    );
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rotated[j][rows - 1 - i] = matrix[i][j];
      }
    }
    
    return rotated;
  }

  List<Point<int>> getBlocks() {
    List<Point<int>> blocks = [];
    List<List<int>> currentShape = getRotatedShape(rotation);
    
    for (int i = 0; i < currentShape.length; i++) {
      for (int j = 0; j < currentShape[i].length; j++) {
        if (currentShape[i][j] == 1) {
          blocks.add(Point(x + j, y + i));
        }
      }
    }
    
    return blocks;
  }
}