import 'package:febacoonline/screens/pages/team_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/team.dart';
import '../../utils/api_service.dart';
import '../../widget/top_team_card.dart';

class TeamsScreen extends StatefulWidget {
  final int? entityId;
  final String? entityName;

  const TeamsScreen({super.key, this.entityId, this.entityName});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<Map<String, dynamic>> allTeams = [];
  List<Map<String, dynamic>> filteredTeams = [];
  String search = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  Future<void> loadTeams() async {
    final data = await ApiService.fetchPublicData();
    final List federationsJson = data["data"];
    final List<Federation> federations =
    federationsJson.map((f) => Federation.fromJson(f)).toList();

    final entityId = widget.entityId;

    final teams = federations
        .expand((f) => f.entities)
        .where((e) => entityId == null || e.id == entityId)
        .expand((e) => e.teams.map((t) => {
      'team': t,
      'entityName': e.name,
    }))
        .toList();

    setState(() {
      allTeams = teams;
      filteredTeams = teams;
      _isLoading = false;
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
        title: Text(widget.entityName ?? 'Toutes les équipes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeamDetailScreen(team: team),
                      ),
                    );
                  },
                  child: TopTeamCard(team: team, entityName: entity),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}