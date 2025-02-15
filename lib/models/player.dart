class Player {
  final String name;
  final String position;
  final double price;
  final String? imageUrl;
  String? clubName; // Pour référencer le club du joueur

  Player({
    required this.name,
    required this.position,
    required this.price,
    this.imageUrl,
    this.clubName,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      position: json['position'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price':price,
      'position': position,
    };
  }
}