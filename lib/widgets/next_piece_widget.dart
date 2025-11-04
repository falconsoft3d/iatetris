import 'package:flutter/material.dart';
import '../models/game_logic.dart';

class NextPieceWidget extends StatelessWidget {
  final GameLogic gameLogic;

  const NextPieceWidget({super.key, required this.gameLogic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...gameLogic.nextPieces.take(3).map((piece) => 
            Container(
              margin: EdgeInsets.only(bottom: 8),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Center(
                child: _buildPreviewPiece(piece),
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildPreviewPiece(dynamic piece) {
    if (piece == null) return Container();
    
    // Simplifcação da prévia da peça
    List<List<int>> shape = piece.shape;
    int size = shape.length > shape[0].length ? shape.length : shape[0].length;
    double cellSize = 40 / size;
    
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          for (int i = 0; i < shape.length; i++)
            for (int j = 0; j < shape[i].length; j++)
              if (shape[i][j] == 1)
                Positioned(
                  left: j * cellSize + (40 - shape[0].length * cellSize) / 2,
                  top: i * cellSize + (40 - shape.length * cellSize) / 2,
                  child: Container(
                    width: cellSize * 0.8,
                    height: cellSize * 0.8,
                    decoration: BoxDecoration(
                      color: _getColorFromPiece(piece),
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Color _getColorFromPiece(dynamic piece) {
    // Simulação das cores baseadas no tipo da peça
    return piece.color ?? Colors.white;
  }
}