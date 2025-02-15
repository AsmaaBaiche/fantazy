// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';

class StorageService {
  static const String KEY_SELECTED_TEAM = 'selected_team';
  static const String KEY_TEAM_LOCKED = 'team_locked';
  static const String KEY_USER_POINTS = 'user_points';

  // Sauvegarder l'équipe sélectionnée
  static Future<void> saveSelectedTeam(List<Player?> team) async {
    final prefs = await SharedPreferences.getInstance();
    final teamJson = team.map((player) => player?.toJson()).toList();
    await prefs.setString(KEY_SELECTED_TEAM, jsonEncode(teamJson));
    await prefs.setBool(KEY_TEAM_LOCKED, true);
  }

  // Vérifier si l'équipe est verrouillée
  static Future<bool> isTeamLocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_TEAM_LOCKED) ?? false;
  }

  // Récupérer l'équipe sauvegardée
  static Future<List<Player?>> getSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final teamJson = prefs.getString(KEY_SELECTED_TEAM);
    if (teamJson == null) return List.generate(15, (index) => null);

    final List<dynamic> decoded = jsonDecode(teamJson);
    return decoded.map((json) => json == null ? null : Player.fromJson(json)).toList();
  }

  // Sauvegarder les points de l'utilisateur
  static Future<void> saveUserPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_USER_POINTS, points);
  }

  // Récupérer les points de l'utilisateur
  static Future<int> getUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY_USER_POINTS) ?? 0;
  }
}