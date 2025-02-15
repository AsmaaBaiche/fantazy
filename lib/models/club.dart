import 'player.dart';

class Club {
  final String name;
  final String kitImageUrl;
  final List<Player> players;

  Club({
    required this.name,
    required this.kitImageUrl,
    required this.players,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      name: json['club_name'] as String,
      kitImageUrl: json['kit_image_url'] as String,
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
    );
  }
}