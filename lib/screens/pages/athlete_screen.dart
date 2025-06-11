import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/athlete.dart';
import '../../utils/api_service.dart';

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

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          athlete.photo != null
                              ? "https://febaco.ourworldtkpl.com/storage/${athlete.photo}"
                              : "https://via.placeholder.com/60",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${athlete.firstName} ${athlete.lastName}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Matricule : ${athlete.matricule ?? '-'}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teamName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}