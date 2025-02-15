import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/club.dart';

class PlayerService {
  static Future<List<Club>> loadPlayers() async {
    try {
      final String response = await rootBundle.loadString('assets/data/Algerian_fantasy_data.json');
      final data = json.decode(response);
      return (data['clubs'] as List).map((club) => Club.fromJson(club)).toList();
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      return [];
    }
  }
  
}