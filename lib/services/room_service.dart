import 'package:client_app/api_endpoints.dart';
import 'package:client_app/models/university.dart';
import 'package:client_app/services/firestore_fetch_service.dart';

import '../models/room.dart';

class RoomService {
  final FirestoreFetchService firestoreFetchService;

  RoomService({
    required this.firestoreFetchService,
  });

  Future<List<University>> getUniversities() async {
    final List<University> universities =
        await firestoreFetchService.getDocuments<University>(
            path: ApiEndpoints.getUniversities(),
            fromDocument: (x) => University.fromDocument(x));

    return universities;
  }

  Future<void> addRoom({required Room room}) async {
    await firestoreFetchService.setOrUpdateDocument(
        path: ApiEndpoints.getRoom(roomId: room.id), data: room.toDocument());
  }
}
