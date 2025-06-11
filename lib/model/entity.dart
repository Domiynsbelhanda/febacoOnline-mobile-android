import 'team.dart';

class Entity {
  final String name;
  final String? description;
  final String? region;
  final String? responsibleName;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? logo;
  final bool? isActive;
  final List<Team> teams;

  Entity({
    required this.name,
    this.description,
    this.region,
    this.responsibleName,
    this.contactEmail,
    this.contactPhone,
    this.address,
    this.logo,
    this.isActive,
    required this.teams,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['name'],
      description: json['description'],
      region: json['region'],
      responsibleName: json['responsible_name'],
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      address: json['address'],
      logo: json['logo'],
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == "1" || json['is_active'] == "true",
      teams: (json['teams'] as List<dynamic>)
          .map((e) => Team.fromJson(e))
          .toList(),
    );
  }
}
