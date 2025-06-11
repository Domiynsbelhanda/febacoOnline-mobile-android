import 'package:flutter/material.dart';
import '../../model/athlete.dart';
import '../../model/transfer.dart';

class TransferCard extends StatelessWidget {
  final Athlete athlete;
  final Transfer transfer;
  final String fromTeam;
  final String toTeam;

  const TransferCard({
    super.key,
    required this.athlete,
    required this.transfer,
    required this.fromTeam,
    required this.toTeam,
  });

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'validé':
        return Colors.green.shade100;
      case 'rejeté':
        return Colors.red.shade100;
      case 'en attente':
      default:
        return Colors.yellow.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 300, // tu peux ajuster selon l'effet désiré
      decoration: BoxDecoration(
        color: getStatusColor(transfer.status),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Image en fond
          Positioned.fill(
            child: Image.network(
              athlete.photo != null
                  ? "https://febaco.ourworldtkpl.com/storage/${athlete.photo}"
                  : "https://via.placeholder.com/300",
              fit: BoxFit.cover,
            ),
          ),
          // Dégradé en bas
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),
          ),

          // Texte par-dessus
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // Fond noir transparent
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${athlete.firstName} ${athlete.lastName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Matricule : ${athlete.matricule ?? 'N/A'}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "De : $fromTeam → À : $toTeam",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Statut : ${transfer.status ?? 'En attente'}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
