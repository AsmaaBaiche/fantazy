class LeaderboardEntry {
  final String userId;
  final String username;
  int points;
  List<String> matchHistory; // Liste des IDs des matchs

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.points = 0,
    this.matchHistory = const [],
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'points': points,
    'matchHistory': matchHistory,
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
    userId: json['userId'],
    username: json['username'],
    points: json['points'],
    matchHistory: List<String>.from(json['matchHistory']),
  );
}