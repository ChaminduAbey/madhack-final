import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/firestore_fetch_service.dart';

import '../api_endpoints.dart';
import '../models/profile.dart';

class UserService {
  final FirestoreFetchService firestoreFetchService;

  UserService({
    required this.firestoreFetchService,
  });

  Future<Profile> getProfile({
    required String uid,
  }) async {
    final Profile profile = await firestoreFetchService.getDocument<Profile>(
        path: ApiEndpoints.getProfile(uid: uid),
        fromDocument: (x) => Profile.fromDocument(x));

    return profile;
  }

  Future<void> insertOrUpdateProfile({
    required Profile profile,
    required String uid,
  }) async {
    await firestoreFetchService.setOrUpdateDocument(
        path: ApiEndpoints.getProfile(uid: uid), data: profile.toDocument());
  }

  Future<List<Profile>> getProfiles() async {
    return await firestoreFetchService.getDocuments<Profile>(
        path: ApiEndpoints.getProfiles(),
        fromDocument: (x) => Profile.fromDocument(x));
  }
}
