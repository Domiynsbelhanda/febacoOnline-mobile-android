import 'athlete.dart';
import 'user.dart';

class Team {
  final String name;
  final String? description;
  final String? responsibleName;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? logo;
  final bool? isActive;
  final String? province;
  final String? categorie;
  final String? ville;
  final String? division;
  final String? couleurs;
  final List<Athlete> athletes;
  final User? user;

  Team({
    required this.name,
    this.description,
    this.responsibleName,
    this.contactEmail,
    this.contactPhone,
    this.address,
    this.logo,
    this.isActive,
    this.province,
    this.categorie,
    this.ville,
    this.division,
    this.couleurs,
    required this.athletes,
    this.user,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      description: json['description'],
      responsibleName: json['responsible_name'],
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      address: json['address'],
      logo: json['logo'],
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == "1" || json['is_active'] == "true",
      province: json['province'],
      categorie: json['categorie'],
      ville: json['ville'],
      division: json['division'],
      couleurs: json['couleurs'],
      athletes: (json['athletes'] as List<dynamic>)
          .map((e) => Athlete.fromJson(e))
          .toList(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
