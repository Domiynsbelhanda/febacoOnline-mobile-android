import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../model/athlete.dart';

class AthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;
  final String teamName;

  const AthleteDetailScreen({
    super.key,
    required this.athlete,
    required this.teamName,
  });

  static const Color primaryColor = Color(0xFF010C19);

  @override
  Widget build(BuildContext context) {
    final qrData = athlete.matricule ?? "${athlete.firstName}_${athlete.lastName}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Licence Athlète'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🔹 Fond avec image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/card.png',
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Contenu
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 16, left: 16, right: 16),
              child: Row(
                children: [
                  // 📷 Photo
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://febaco.ourworldtkpl.com/storage/${athlete.photo ?? 'placeholder.png'}",
                        height: 140,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // ℹ️ Infos + QR
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${athlete.firstName} ${athlete.lastName}".toUpperCase(),
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _infoLine("Équipe", teamName),
                            _infoLine("Poste", athlete.position ?? '-'),
                            _infoLine("Genre", athlete.gender ?? '-'),
                            _infoLine("Dossard", athlete.jerseyNumber ?? '-'),
                            _infoLine("Matricule", athlete.matricule ?? 'N/A', small: true),
                          ],
                        ),

                        // 🔹 QR Code
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLine(String label, String value, {bool small = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          text: "$label : ",
          style: TextStyle(
            color: primaryColor.withOpacity(small ? 0.6 : 0.85),
            fontSize: small ? 12 : 14,
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor.withOpacity(small ? 0.6 : 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}