import 'athlete.dart';
import 'team.dart';
import 'user.dart';

class Transfer {
  final int? id;
  final int? athleteId;
  final int? fromTeamId;
  final int? toTeamId;
  final User? initiatedBy;
  final String? transferDate;
  final String? type;
  final String? status;
  final bool? confirmationByDestination;
  final bool? confirmationByFederation;
  final String? notes;

  Transfer({
    this.id,
    this.athleteId,
    this.fromTeamId,
    this.toTeamId,
    this.initiatedBy,
    this.transferDate,
    this.type,
    this.status,
    this.confirmationByDestination,
    this.confirmationByFederation,
    this.notes,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      athleteId: json['athlete_id'] != null
          ? int.tryParse(json['athlete_id'].toString())
          : null,
      fromTeamId: json['from_team_id'] != null
          ? int.tryParse(json['from_team_id'].toString())
          : null,
      toTeamId: json['to_team_id'] != null
          ? int.tryParse(json['to_team_id'].toString())
          : null,
      initiatedBy: json['initiated_by'] != null
          ? User.fromJson(json['initiated_by'])
          : null,
      transferDate: json['transfer_date'],
      type: json['type'],
      status: json['status'],
      confirmationByDestination: json['confirmation_by_destination'] == true ||
          json['confirmation_by_destination'] == 1,
      confirmationByFederation: json['confirmation_by_federation'] == true ||
          json['confirmation_by_federation'] == 1,
      notes: json['notes'],
    );
  }
}