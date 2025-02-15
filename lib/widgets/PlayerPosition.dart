import 'package:flutter/material.dart';

class PlayerPosition extends StatelessWidget {
  final double x;
  final double y;
  final String? playerName;
  final String? kitImageUrl;
  final VoidCallback onTap;
  final bool isReserve;
  final String? positionLabel;

  const PlayerPosition({
    super.key,
    required this.x,
    required this.y,
    this.playerName,
    this.kitImageUrl,
    required this.onTap,
    required this.isReserve,
    this.positionLabel,
  });

  /// Vérifie si l'URL du kit est valide, sinon charge une image par défaut
  String? get validKitImageUrl => kitImageUrl != null && kitImageUrl!.isNotEmpty 
      ? 'assets/$kitImageUrl' 
      : 'assets/kits/default_kit.png';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: playerName != null ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: Image.asset(
                validKitImageUrl!, // ✅ Utilisation de l'URL corrigée
                fit: BoxFit.contain,
              ),
            ),
            if (playerName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  playerName!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
