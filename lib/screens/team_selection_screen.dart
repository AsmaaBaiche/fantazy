import 'package:flutter/material.dart';
import '../models/club.dart';
import '../models/player.dart';
import '../services/PlayerService.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/PlayerPosition.dart';
import '../services/storage_service.dart';
import '../services/match_service.dart';

class TeamSelectionScreen extends StatefulWidget {
  const TeamSelectionScreen({super.key});

  @override
  State<TeamSelectionScreen> createState() => _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen> {
  List<Club> clubs = [];
  List<Player?> selectedPlayers = List.generate(15, (index) => null);
  double totalBudget = 100.0;
  double spentBudget = 0.0;
  Club? selectedClub;

  // Positions des joueurs sur le terrain (x, y en pourcentage)
  final List<Map<String, double>> positions = [
  // Gardien
  {'x': 0.5, 'y': 0.75},
  // Défenseurs
  {'x': 0.2, 'y': 0.6},
  {'x': 0.4, 'y': 0.6},
  {'x': 0.6, 'y': 0.6},
  {'x': 0.8, 'y': 0.6},
  // Milieux
  {'x': 0.15, 'y': 0.45},
  {'x': 0.38, 'y': 0.45},
  {'x': 0.62, 'y': 0.45},
  {'x': 0.85, 'y': 0.45},
  // Attaquants
  {'x': 0.35, 'y': 0.25},
  {'x': 0.65, 'y': 0.25},
  // Remplaçants (alignés verticalement sur le côté droit)
  {'x': 0.92, 'y': 0.2},
  {'x': 0.92, 'y': 0.35},
  {'x': 0.92, 'y': 0.5},
  {'x': 0.92, 'y': 0.65},
];


  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    try {
      final loadedClubs = await PlayerService.loadPlayers();
      setState(() {
        clubs = loadedClubs;
        print(clubs[0].kitImageUrl);
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des clubs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond du terrain
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/pitch.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 60, // Ajoute un padding pour la barre de navigation
          ),
          child: Stack(
            children: List.generate(15, (index) {
              final position = positions[index];
              final player = selectedPlayers[index];
              final isReserve = index >= 11;

              return PlayerPosition(
                x: position['x']! * MediaQuery.of(context).size.width,
                y: position['y']! * (MediaQuery.of(context).size.height - 80), // Soustrait la hauteur de la barre de navigation
                playerName: player?.name,
                kitImageUrl: player != null ? '${player.clubName}' : "Club_Kits/default.png",
                onTap: () => _showPlayerSelection(index),
                isReserve: isReserve,
                positionLabel: _getPositionLabel(index),
              );
            }),
          ),
        ),

          // Interface utilisateur
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildTeamSelector(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/leaderboard');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  String _getPositionLabel(int index) {
    if (index == 0) return 'GK';
    if (index >= 1 && index <= 4) return 'DF';
    if (index >= 5 && index <= 8) return 'MF';
    if (index >= 9 && index <= 10) return 'FW';
    return 'R${index - 10}'; // Pour les remplaçants
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget restant',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 77, 74, 74),
                    ),
                  ),
                  Text(
                    '${(totalBudget - spentBudget).toStringAsFixed(1)}M DZD',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 227, 194, 6),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _validateTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Valider l\'équipe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: spentBudget / totalBudget,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              spentBudget < totalBudget ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSelector() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                final club = clubs[index];
                final isSelected = selectedClub?.name == club.name;

                return GestureDetector(
                  onTap: () => setState(() => selectedClub = club),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8FF54)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Image.asset(
                          'assets/${club.kitImageUrl}',
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          club.name.split(' ')[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
void _showPlayerSelection(int index) {
  if (selectedClub == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sélectionnez d\'abord une équipe'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Récupérer la position requise pour ce joueur
  final position = _getPositionLabel(index);
print(position);
print("hhhhhhhhhhhhhhhhhh");
  // Filtrer les joueurs de l'équipe sélectionnée par position
  final availablePlayers = selectedClub!.players
      .where((player) => player.position == position || index >= 11) // Les remplaçants peuvent être de n'importe quelle position
      .toList();

  // Vérifier s'il y a des joueurs à afficher
  if (availablePlayers.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aucun joueur disponible pour cette position'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  // Affichage du modal de sélection des joueurs
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedClub!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sélectionnez un $position',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: availablePlayers.length,
              itemBuilder: (context, playerIndex) {
                final player = availablePlayers[playerIndex];
                final isSelected = selectedPlayers.contains(player);

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/${selectedClub!.kitImageUrl}',
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    player.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    '${player.position} - ${player.price}M DZD',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  enabled: !isSelected,
                  onTap: () {
                    if (_canSelectPlayer(player)) {
                      setState(() {
                        // Retirer l'ancien joueur du budget si nécessaire
                        if (selectedPlayers[index] != null) {
                          spentBudget -= selectedPlayers[index]!.price;
                        }
                        // Ajouter le nouveau joueur
                       
                        print(player.clubName);
                        player.clubName =selectedClub?.kitImageUrl;
                        selectedPlayers[index] = player;
                        spentBudget += player.price;
                      });
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


  bool _canSelectPlayer(Player player) {
    if (spentBudget + player.price > totalBudget) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget insuffisant'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

void _validateTeam() async {
  final selectedCount = selectedPlayers.where((p) => p != null).length;
  
  if (selectedCount < 15) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sélectionnez ${15 - selectedCount} joueur${selectedCount == 14 ? '' : 's'} supplémentaire${selectedCount == 14 ? '' : 's'}',
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Vérifier si l'équipe est déjà verrouillée
  final isLocked = await StorageService.isTeamLocked();
  if (isLocked) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre équipe est déjà verrouillée et ne peut plus être modifiée'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Sauvegarder l'équipe
  await StorageService.saveSelectedTeam(selectedPlayers);
  
  // Simuler les points initiaux
  int totalPoints = 0;
  for (var player in selectedPlayers) {
    if (player != null) {
      final stats = MatchService.calculatePlayerPoints(player);
      totalPoints += MatchService.calculateTotalPoints(stats);
    }
  }
  
  await StorageService.saveUserPoints(totalPoints);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Équipe sauvegardée avec succès!'),
      backgroundColor: Colors.green,
    ),
  );

  // Rediriger vers l'écran d'accueil
  Navigator.pushReplacementNamed(context, '/home');
}
}