// lib/services/match_service.dart
import 'dart:math';
import '../models/player.dart';

class MatchService {
  static final Random _random = Random();

  static Map<String, dynamic> simulateMatch() {
    final homeGoals = _random.nextInt(4);
    final awayGoals = _random.nextInt(4);
    
    return {
      'homeTeam': 'MC Alger',
      'awayTeam': 'USM Alger',
      'homeScore': homeGoals,
      'awayScore': awayGoals,
    };
  }

  static Map<String, int> calculatePlayerPoints(Player player) {
    final points = <String, int>{
      'goals': 0,
      'assists': 0,
      'cleanSheet': 0,
      'yellowCards': 0,
      'redCards': 0,
    };

    // Simuler les performances du joueur
    if (_random.nextDouble() < 0.3) points['goals'] = _random.nextInt(2);
    if (_random.nextDouble() < 0.2) points['assists'] = _random.nextInt(2);
    if (_random.nextDouble() < 0.1) points['yellowCards'] = 1;
    if (_random.nextDouble() < 0.05) points['redCards'] = 1;
    
    if (player.position == 'GK' || player.position == 'DF') {
      if (_random.nextDouble() < 0.4) points['cleanSheet'] = 1;
    }

    return points;
  }

  static int calculateTotalPoints(Map<String, int> stats) {
    return stats['goals']! * 5 +
           stats['assists']! * 3 +
           stats['cleanSheet']! * 4 -
           stats['yellowCards']! * 2 -
           stats['redCards']! * 5;
  }
}