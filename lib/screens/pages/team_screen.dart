import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/team.dart';
import '../../utils/api_service.dart';
import '../../widget/top_team_card.dart'; // Assure-toi que ce fichier contient le widget utilisé

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<Map<String, dynamic>> allTeams = [];
  List<Map<String, dynamic>> filteredTeams = [];
  String search = "";

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  Future<void> loadTeams() async {
    final data = await ApiService.fetchPublicData();
    final List federationsJson = data["data"];
    final List<Federation> federations = federationsJson
        .map((f) => Federation.fromJson(f))
        .toList();

    final teams = federations
        .expand((f) => f.entities)
        .expand((e) => e.teams.map((t) => {
      'team': t,
      'entityName': e.name,
    }))
        .toList();

    setState(() {
      allTeams = teams;
      filteredTeams = teams;
    });
  }

  void onSearch(String value) {
    final lower = value.toLowerCase();
    final results = allTeams.where((item) {
      final Team team = item['team'];
      return team.name.toLowerCase().contains(lower);
    }).toList();

    setState(() {
      search = value;
      filteredTeams = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Équipes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Rechercher une équipe...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredTeams.isEmpty
                ? const Center(child: Text("Aucune équipe trouvée."))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredTeams.length,
              itemBuilder: (context, index) {
                final Team team =
                filteredTeams[index]['team'] as Team;
                final String entity =
                filteredTeams[index]['entityName'] as String;

                return TopTeamCard(team: team, entityName: entity);
              },
            ),
          ),
        ],
      ),
    );
  }
}