class MatchStats {
  final String playerName;
  final String position;
  int goals;
  int assists;
  bool cleanSheet;
  bool yellowCard;
  bool redCard;
  int points;

  MatchStats({
    required this.playerName,
    required this.position,
    this.goals = 0,
    this.assists = 0,
    this.cleanSheet = false,
    this.yellowCard = false,
    this.redCard = false,
    this.points = 0,
  });

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'position': position,
    'goals': goals,
    'assists': assists,
    'cleanSheet': cleanSheet,
    'yellowCard': yellowCard,
    'redCard': redCard,
    'points': points,
  };

  factory MatchStats.fromJson(Map<String, dynamic> json) => MatchStats(
    playerName: json['playerName'],
    position: json['position'],
    goals: json['goals'],
    assists: json['assists'],
    cleanSheet: json['cleanSheet'],
    yellowCard: json['yellowCard'],
    redCard: json['redCard'],
    points: json['points'],
  );
}
