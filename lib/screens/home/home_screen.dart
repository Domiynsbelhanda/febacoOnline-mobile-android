import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/team.dart';
import '../../utils/api_service.dart';
import '../../widget/entity_card.dart';
import '../../widget/top_team_card.dart';
import '../pages/team_detail_screen.dart';
import '../pages/team_screen.dart';
import 'components/secondary_course_card.dart';
import '../../model/course.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService.fetchPublicData(), // appel API
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            }

            // Parsing des données
            final List federationsJson = snapshot.data!["data"];
            final List<Federation> federations = federationsJson
                .map((f) => Federation.fromJson(f))
                .toList();

            final entities = federations
                .expand((f) => f.entities)
                .toList();

            final teams = federations
                .expand((f) => f.entities)
                .expand((e) => e.teams.map((t) => {'team': t, 'entityName': e.name}))
                .toList();

            final topTeams = teams.take(5).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Accueil",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Entente Urbaine",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  // Section horizontale des entités
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: entities.map((entity) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamsScreen(
                                    entityId: entity.id,
                                    entityName: entity.name,
                                  ),
                                ),
                              );
                            },
                            child: EntityCard(
                              name: entity.name,
                              logoUrl: "https://febaco.ourworldtkpl.com/storage/${entity.logo}" ?? 'https://via.placeholder.com/150',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Top Equipe",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: topTeams.map((data) {

                        final Team team = data['team'] as Team;
                        final String entity = data['entityName'] as String;

                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailScreen(team: team),
                                ),
                            );
                          },
                            child: TopTeamCard(team: team, entityName: entity)
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}