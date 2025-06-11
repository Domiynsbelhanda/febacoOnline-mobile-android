import 'entity.dart';

class Federation {
  final String name;
  final String? description;
  final String? logo;
  final List<Entity> entities;

  Federation({
    required this.name,
    this.description,
    this.logo,
    required this.entities,
  });

  factory Federation.fromJson(Map<String, dynamic> json) {
    return Federation(
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      entities: (json['entities'] as List<dynamic>)
          .map((e) => Entity.fromJson(e))
          .toList(),
    );
  }
}