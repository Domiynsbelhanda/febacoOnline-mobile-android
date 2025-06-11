import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../model/transfer.dart';
import '../../model/athlete.dart';
import '../../model/team.dart';
import '../../utils/api_service.dart';
import '../../widget/transfert_card.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  List<TransferDisplayData> transfers = [];
  List<TransferDisplayData> filteredTransfers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadTransfers();
  }

  Future<void> loadTransfers() async {
    final data = await ApiService.fetchPublicData();
    final List federationsJson = data["data"];
    final List<Federation> federations =
    federationsJson.map((f) => Federation.fromJson(f)).toList();

    final allTeams = federations
        .expand((f) => f.entities)
        .expand((e) => e.teams)
        .toList();

    final allTransfers = federations
        .expand((f) => f.entities)
        .expand((e) => e.teams)
        .expand((t) => t.athletes)
        .expand((a) => a.transfers.map((tr) {
      final from = allTeams.firstWhere(
            (team) => team.id == tr.fromTeamId,
        orElse: () => Team(name: 'Inconnue', athletes: []),
      );
      final to = allTeams.firstWhere(
            (team) => team.id == tr.toTeamId,
        orElse: () => Team(name: 'Inconnue', athletes: []),
      );

      return TransferDisplayData(
        athlete: a,
        transfer: tr,
        fromTeam: from.name,
        toTeam: to.name,
      );
    }))
        .toList();

    setState(() {
      transfers = allTransfers;
      filteredTransfers = allTransfers;
    });
  }

  void filterTransfers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredTransfers = transfers.where((item) {
        final athlete = item.athlete;
        return (athlete.firstName.toLowerCase().contains(searchQuery) ||
            athlete.lastName.toLowerCase().contains(searchQuery) ||
            (athlete.matricule?.toLowerCase().contains(searchQuery) ?? false) ||
            item.fromTeam.toLowerCase().contains(searchQuery) ||
            item.toTeam.toLowerCase().contains(searchQuery));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: transfers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText:
                "Rechercher par joueur, matricule ou équipe...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: filterTransfers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredTransfers.length,
              itemBuilder: (context, index) {
                final item = filteredTransfers[index];
                return TransferCard(
                  athlete: item.athlete,
                  transfer: item.transfer,
                  fromTeam: item.fromTeam,
                  toTeam: item.toTeam,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransferDisplayData {
  final Athlete athlete;
  final Transfer transfer;
  final String fromTeam;
  final String toTeam;

  TransferDisplayData({
    required this.athlete,
    required this.transfer,
    required this.fromTeam,
    required this.toTeam,
  });
}
