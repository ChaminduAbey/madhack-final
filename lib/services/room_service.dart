import 'package:client_app/api_endpoints.dart';
import 'package:client_app/models/university.dart';
import 'package:client_app/services/firestore_fetch_service.dart';

import '../models/property.dart';

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

  Future<void> addProperty({required Property room}) async {
    await firestoreFetchService.setOrUpdateDocument(
        path: ApiEndpoints.getProperty(propertyId: room.id),
        data: room.toDocument());
  }

  Future<List<Property>> getProperties() async {
    return await firestoreFetchService.getDocuments<Property>(
        path: ApiEndpoints.getProperties(),
        fromDocument: (x) => Property.fromDocument(x));
  }

  Future<Property> getProperty({required String propertyId}) async {
    return await firestoreFetchService.getDocument<Property>(
        path: ApiEndpoints.getProperty(propertyId: propertyId),
        fromDocument: (x) => Property.fromDocument(x));
  }
}
