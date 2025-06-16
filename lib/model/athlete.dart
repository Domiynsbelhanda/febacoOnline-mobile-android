import 'transfer.dart';
import 'performance.dart';

class Athlete {
  final int? id; // <- Ajouté
  final int? teamId;
  final String lastName;
  final String? middleName;
  final String firstName;
  final String? birthDate;
  final String? birthPlace;
  final String? nationality;
  final String? gender;
  final String? matricule;
  final String? photo;
  final double? height;
  final double? weight;
  final String? position;
  final String? jerseyNumber;
  final String? contactEmail;
  final String? contactPhone;
  final bool? isActive;
  final List<Transfer> transfers;
  final List<Performance> performances;

  Athlete({
    this.id, // <- Ajouté ici
    this.teamId,
    required this.lastName,
    this.middleName,
    required this.firstName,
    this.birthDate,
    this.birthPlace,
    this.nationality,
    this.gender,
    this.matricule,
    this.photo,
    this.height,
    this.weight,
    this.position,
    this.jerseyNumber,
    this.contactEmail,
    this.contactPhone,
    this.isActive,
    required this.transfers,
    required this.performances,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null, // <- Lecture de l'ID
      teamId: json['team_id'] != null
          ? int.tryParse(json['team_id'].toString())
          : null,
      lastName: json['last_name'],
      middleName: json['middle_name'],
      firstName: json['first_name'],
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      nationality: json['nationality'],
      gender: json['gender'],
      matricule: json['matricule'],
      photo: json['photo'],
      height: json['height'] != null ? double.tryParse(json['height'].toString()) : null,
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      position: json['position'],
      jerseyNumber: json['jersey_number'],
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == "1" || json['is_active'] == "true",
      transfers: (json['transfers'] as List<dynamic>)
          .map((e) => Transfer.fromJson(e))
          .toList(),
      performances: (json['performances'] as List<dynamic>)
          .map((e) => Performance.fromJson(e))
          .toList(),
    );
  }
}