import 'package:flutter/material.dart';
import '../../model/team.dart';
import '../../model/athlete.dart';
import '../../model/transfer.dart';
import '../../widget/athlete_tile.dart';
import '../../widget/transfert_card.dart';
import 'athlete_detail_screen.dart';

class TeamDetailScreen extends StatelessWidget {
  final Team team;

  const TeamDetailScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail de l'équipe"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            // --- PRESENTATION DE L'ÉQUIPE ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      if (team.logo != null)
                        Image.network(
                          "https://febaco.ourworldtkpl.com/storage/${team.logo}",
                          height: 150,
                        ),
                      const SizedBox(width: 16),

                      // Bloc 1 : Identité de l’équipe
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              if (team.description != null)
                                Text(team.description!),
                              if (team.couleurs != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text("Couleurs : ${team.couleurs}"),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 12),

                  // Bloc 2 : Contact & localisation
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (team.contactEmail != null)
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 20),
                                const SizedBox(width: 8),
                                Text(team.contactEmail!),
                              ],
                            ),
                          if (team.contactPhone != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone_outlined, size: 20),
                                  const SizedBox(width: 8),
                                  Text(team.contactPhone!),
                                ],
                              ),
                            ),
                          if (team.address != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 20),
                                  const SizedBox(width: 8),
                                  Flexible(child: Text(team.address!)),
                                ],
                              ),
                            ),
                          if (team.province != null || team.ville != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.map_outlined, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${team.province ?? 'N/A'} / ${team.ville ?? 'N/A'}",
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // --- TAB BAR ---
            const TabBar(
              tabs: [
                Tab(text: 'Joueurs'),
                Tab(text: 'Transferts'),
              ],
              labelColor: Colors.black,
            ),

            // --- CONTENU DES TABS ---
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1 : Liste des joueurs
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: team.athletes.length,
                    itemBuilder: (context, index) {
                      final Athlete athlete = team.athletes[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AthleteDetailScreen(
                                  athlete: athlete,
                                  teamName: team.name,
                                ),
                              ),
                            );
                          },
                          child: AthleteTile(athlete: athlete, teamName: team.name,)
                      );
                    },
                  ),

                  // Tab 2 : Liste des transferts
                  Builder(
                    builder: (context) {
                      final transfers = team.athletes
                          .expand((a) => a.transfers)
                          .where((t) =>
                      t.fromTeamId == team.id || t.toTeamId == team.id)
                          .toList();

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: transfers.length,
                        itemBuilder: (context, index) {
                          final transfer = transfers[index];
                          final athlete = team.athletes.firstWhere(
                                  (a) => a.id == transfer.athleteId);

                          final from = transfer.fromTeamId == team.id
                              ? team.name
                              : "Autre équipe";
                          final to = transfer.toTeamId == team.id
                              ? team.name
                              : "Autre équipe";

                          return TransferCard(
                            athlete: athlete,
                            transfer: transfer,
                            fromTeam: from,
                            toTeam: to,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}