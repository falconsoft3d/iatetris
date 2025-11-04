class GameRecord {
  final int? id;
  final int score;
  final int level;
  final int lines;
  final DateTime date;
  final int duration; // Duration in seconds

  GameRecord({
    this.id,
    required this.score,
    required this.level,
    required this.lines,
    required this.date,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'level': level,
      'lines': lines,
      'date': date.millisecondsSinceEpoch,
      'duration': duration,
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      id: map['id'],
      score: map['score'],
      level: map['level'],
      lines: map['lines'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      duration: map['duration'],
    );
  }

  @override
  String toString() {
    return 'GameRecord{id: $id, score: $score, level: $level, lines: $lines, date: $date, duration: $duration}';
  }
}