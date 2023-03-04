import 'package:client_app/models/faculty.dart';

class FacultyRoomTime {
  final Faculty faculty;

  final Duration duration;

  FacultyRoomTime({
    required this.faculty,
    required this.duration,
  });

  factory FacultyRoomTime.fromDocument(Map<String, dynamic> data) {
    return FacultyRoomTime(
      faculty: Faculty.fromDocument(data['faculty']),
      duration: Duration(minutes: data['duration']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'faculty': faculty.toDocument(),
      'duration': duration.inMinutes,
    };
  }
}
