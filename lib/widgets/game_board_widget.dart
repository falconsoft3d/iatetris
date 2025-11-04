import 'package:flutter/material.dart';
import '../models/game_logic.dart';

class GameBoardWidget extends StatelessWidget {
  final GameLogic gameLogic;

  const GameBoardWidget({super.key, required this.gameLogic});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: AspectRatio(
        aspectRatio: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(20, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(10, (col) {
                    final cell = gameLogic.boardDisplay[row][col];
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: cell['filled'] 
                            ? _getColorFromValue(cell['color'])
                            : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                          border: cell['filled'] 
                            ? Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 0.5,
                              )
                            : Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 0.2,
                              ),
                        ),
                        child: cell['isCurrentPiece'] 
                          ? Container(
                              decoration: BoxDecoration(
                                color: _getColorFromValue(cell['color']).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            )
                          : null,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Color _getColorFromValue(int colorValue) {
    if (colorValue == 0) return Colors.transparent;
    
    // Converte o hash da cor em uma cor específica
    switch (colorValue.abs() % 7) {
      case 0:
        return Colors.cyan;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.orange;
      default:
        return Colors.white;
    }
  }
}