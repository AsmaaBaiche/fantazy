import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameService {
  static Future<void> updateLeaderboard(List<Map<String, dynamic>> matchResults) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? leaderboardData = prefs.getString('leaderboard');
    List<Map<String, dynamic>> leaderboard = leaderboardData != null
        ? List<Map<String, dynamic>>.from(json.decode(leaderboardData))
        : [];

    for (var result in matchResults) {
      var existing = leaderboard.firstWhere(
          (entry) => entry['name'] == result['name'],
          orElse: () => {"name": result['name'], "points": 0});
      
      existing["points"] += result["points"];
      leaderboard.removeWhere((entry) => entry['name'] == result['name']);
      leaderboard.add(existing);
    }

    leaderboard.sort((a, b) => b["points"].compareTo(a["points"]));
    prefs.setString('leaderboard', json.encode(leaderboard));
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? leaderboardData = prefs.getString('leaderboard');
    return leaderboardData != null ? List<Map<String, dynamic>>.from(json.decode(leaderboardData)) : [];
  }
}
