import 'package:febacoonline/widget/athlete_tile.dart';
import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/athlete.dart';
import '../../utils/api_service.dart';
import 'athlete_detail_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  List<Map<String, dynamic>> allAthletes = [];
  List<Map<String, dynamic>> filteredAthletes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAthletes();
  }

  Future<void> loadAthletes() async {
    final data = await ApiService.fetchPublicData();
    final List federationsJson = data["data"];
    final List<Federation> federations = federationsJson
        .map((f) => Federation.fromJson(f))
        .toList();

    final athletesList = federations
        .expand((f) => f.entities)
        .expand((e) => e.teams)
        .expand((t) => t.athletes.map((a) => {
      'athlete': a,
      'team': t.name,
    }))
        .toList();

    setState(() {
      allAthletes = athletesList;
      filteredAthletes = athletesList;
    });
  }

  void filterAthletes(String query) {
    final filtered = allAthletes.where((entry) {
      final Athlete a = entry['athlete'];
      final fullName = "${a.firstName} ${a.lastName}".toLowerCase();
      final matricule = (a.matricule ?? "").toLowerCase();
      return fullName.contains(query.toLowerCase()) ||
          matricule.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredAthletes = filtered;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlètes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: searchController,
              onChanged: filterAthletes,
              decoration: InputDecoration(
                hintText: "Rechercher un athlète...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // List view
          Expanded(
            child: filteredAthletes.isEmpty
                ? const Center(child: Text("Aucun athlète trouvé"))
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredAthletes.length,
              itemBuilder: (context, index) {
                final Athlete athlete =
                filteredAthletes[index]['athlete'] as Athlete;
                final String teamName =
                filteredAthletes[index]['team'] as String;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AthleteDetailScreen(
                          athlete: athlete,
                          teamName: teamName,
                        ),
                      ),
                    );
                  },
                  child: AthleteTile(athlete: athlete, teamName: teamName,)
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}