import 'package:client_app/models/profile.dart';

import '../main.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';

class UpdateProfileController {
  Future<void> updateProfile({required Profile profile}) async {
    await getIt<UserService>().insertOrUpdateProfile(
      uid: profile.id,
      profile: profile,
    );

    final updatedProfile = await getIt<UserService>().getProfile(
      uid: profile.id,
    );

    getIt.get<UserProvider>().setProfile(updatedProfile);
  }
}
