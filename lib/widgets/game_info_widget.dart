import 'package:flutter/material.dart';
import '../models/game_logic.dart';

class GameInfoWidget extends StatelessWidget {
  final GameLogic gameLogic;

  const GameInfoWidget({super.key, required this.gameLogic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard('Score', gameLogic.score.toString()),
        SizedBox(height: 8),
        _buildInfoCard('Level', gameLogic.level.toString()),
        SizedBox(height: 8),
        _buildInfoCard('Lines', gameLogic.totalLines.toString()),
        SizedBox(height: 8),
        _buildInfoCard('Best', gameLogic.personalBest?.score.toString() ?? '0'),
        SizedBox(height: 12),
        _buildInstructions(),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _buildInstructionRow('↑ / Space', 'Rotate'),
          _buildInstructionRow('← →', 'Move'),
          _buildInstructionRow('↓', 'Soft Drop'),
          _buildInstructionRow('Enter', 'Hard Drop'),
          _buildInstructionRow('P', 'Pause'),
          _buildInstructionRow('R', 'Restart'),
          _buildInstructionRow('📊', 'View Records'),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String key, String action) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              key,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              action,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}