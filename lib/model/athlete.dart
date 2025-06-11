import 'transfer.dart';
import 'performance.dart';

class Athlete {
  final String lastName;
  final String? middleName;
  final String firstName;
  final String? birthDate;
  final String? birthPlace;
  final String? nationality;
  final String? gender;
  final String? photo;
  final List<Transfer> transfers;
  final List<Performance> performances;

  Athlete({
    required this.lastName,
    this.middleName,
    required this.firstName,
    this.birthDate,
    this.birthPlace,
    this.nationality,
    this.gender,
    this.photo,
    required this.transfers,
    required this.performances,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      lastName: json['last_name'],
      middleName: json['middle_name'],
      firstName: json['first_name'],
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      nationality: json['nationality'],
      gender: json['gender'],
      photo: json['photo'],
      transfers: (json['transfers'] as List<dynamic>)
          .map((e) => Transfer.fromJson(e))
          .toList(),
      performances: (json['performances'] as List<dynamic>)
          .map((e) => Performance.fromJson(e))
          .toList(),
    );
  }
}
