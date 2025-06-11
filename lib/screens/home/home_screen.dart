import 'package:flutter/material.dart';
import '../../model/federation.dart';
import '../../utils/api_service.dart';
import '../../widget/entity_card.dart';
import 'components/secondary_course_card.dart';
import '../../model/course.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService.fetchPublicData(), // appel API
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            }

            // Parsing des données
            final List federationsJson = snapshot.data!["data"];
            final List<Federation> federations = federationsJson
                .map((f) => Federation.fromJson(f))
                .toList();

            final entities = federations
                .expand((f) => f.entities)
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Accueil",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Recent",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  // Section horizontale des entités
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: entities.map((entity) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: EntityCard(
                            name: entity.name,
                            logoUrl: "https://febaco.ourworldtkpl.com//storage/${entity.logo}" ??
                                'https://via.placeholder.com/150',
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Recent",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Static section (peut être remplacée plus tard)
                  ...recentCourses.map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: SecondaryCourseCard(
                      title: course.title,
                      iconsSrc: course.iconSrc,
                      colorl: course.color,
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}