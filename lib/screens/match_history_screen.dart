import 'dart:math';

class MatchSimulation {
  static List<Map<String, dynamic>> simulateMatch(List<dynamic> players) {
    Random rand = Random();
    List<Map<String, dynamic>> matchStats = [];

    for (var player in players) {
      int goals = rand.nextInt(3); // Max 2 buts
      int assists = rand.nextInt(2); // Max 1 passe
      int yellowCards = rand.nextInt(2); // 0 ou 1 carton
      int redCard = yellowCards == 1 ? rand.nextInt(2) : 0; // Si jaune, possible rouge

      int points = (goals * 5) + (assists * 3) - (yellowCards * 2) - (redCard * 5);

      matchStats.add({
        "name": player["name"],
        "position": player["position"],
        "club": player["club"],
        "goals": goals,
        "assists": assists,
        "yellowCards": yellowCards,
        "redCard": redCard,
        "points": points
      });
    }
    return matchStats;
  }
}
