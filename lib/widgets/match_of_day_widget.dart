// lib/widgets/match_of_day_widget.dart
import 'package:flutter/material.dart';
import '../services/match_service.dart';
import '../services/storage_service.dart';

class MatchOfDayWidget extends StatefulWidget {
  const MatchOfDayWidget({Key? key}) : super(key: key);

  @override
  State<MatchOfDayWidget> createState() => _MatchOfDayWidgetState();
}

class _MatchOfDayWidgetState extends State<MatchOfDayWidget> {
  Map<String, dynamic>? matchData;
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    _simulateMatch();
  }

  Future<void> _simulateMatch() async {
    final match = MatchService.simulateMatch();
    final points = await StorageService.getUserPoints();
    
    setState(() {
      matchData = match;
      userPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (matchData == null) return const CircularProgressIndicator();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Match du Jour',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                matchData!['homeTeam'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${matchData!['homeScore']} - ${matchData!['awayScore']}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                matchData!['awayTeam'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Vos points: $userPoints',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}