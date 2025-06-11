import 'package:flutter/material.dart';
import '../../model/athlete.dart';

class AthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;
  final String teamName;

  const AthleteDetailScreen({
    super.key,
    required this.athlete,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Licence Athlète'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent, width: 2),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black26,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://febaco.ourworldtkpl.com/storage/${athlete.photo ?? 'placeholder.png'}",
                  width: 140,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LICENSE TO COMPETE",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "1. ${athlete.firstName.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "2. ${athlete.lastName.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoLine("Date de naissance", athlete.birthDate ?? "-"),
                    _infoLine("Lieu", athlete.birthPlace ?? "-"),
                    _infoLine("Taille", athlete.height != null ? "${athlete.height} cm" : "-"),
                    _infoLine("Poids", athlete.weight != null ? "${athlete.weight} kg" : "-"),
                    _infoLine("Nationalité", athlete.nationality ?? "-"),
                    _infoLine("Équipe", teamName),
                    _infoLine("Position", athlete.position ?? "-"),
                    _infoLine("Dossard", athlete.jerseyNumber ?? "-"),
                    const SizedBox(height: 8),
                    Text(
                      "Matricule : ${athlete.matricule ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          text: "$label : ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
