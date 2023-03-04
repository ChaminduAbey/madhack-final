import 'package:client_app/models/profile.dart';
import 'package:client_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

class SignupController {
  Future<void> signup({required Profile profile}) async {
    try {
      final User user = getIt.get<AuthService>().getFBUser();

      getIt
          .get<UserService>()
          .insertOrUpdateProfile(profile: profile, uid: user.uid);

      final Profile newProfile = await getIt<UserService>().getProfile(
        uid: user.uid,
      );

      getIt.get<UserProvider>().setProfile(newProfile);
    } catch (ex) {
      rethrow;
    }
  }
}
