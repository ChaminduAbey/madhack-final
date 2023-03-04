import 'package:client_app/models/faculty.dart';

class University {
  final String name;
  final List<Faculty> faculties;
  final String id;

  University({
    required this.name,
    required this.faculties,
    required this.id,
  });

  factory University.fromDocument(Map<String, dynamic> data) {
    return University(
      name: data['name'],
      faculties: (data['faculties'] as List<dynamic>)
          .map((e) => Faculty.fromDocument(e))
          .toList(),
      id: data['id'],
    );
  }
}
