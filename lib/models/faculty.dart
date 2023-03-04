class Faculty {
  final String name;
  final String id;
  final String universityId;

  Faculty({
    required this.name,
    required this.id,
    required this.universityId,
  });

  factory Faculty.fromDocument(Map<String, dynamic> data) {
    return Faculty(
      name: data['name'],
      id: data['id'],
      universityId: data['universityId'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'id': id,
      'universityId': universityId,
    };
  }
}
