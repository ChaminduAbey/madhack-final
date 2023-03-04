import 'package:client_app/models/profile.dart';
import 'package:client_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../main.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class SignupController {
  Future<void> signup({required Profile profile}) async {
    try {
      final User user = getIt.get<AuthService>().getFBUser();

      getIt
          .get<UserService>()
          .insertOrUpdateProfile(profile: profile, uid: user.uid);

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          id: user.uid,
          firstName: user.displayName ?? '',
          imageUrl: profile.photo.url,
        ),
      );

      final Profile newProfile = await getIt<UserService>().getProfile(
        uid: user.uid,
      );

      getIt.get<UserProvider>().setProfile(newProfile);
    } catch (ex) {
      rethrow;
    }
  }
}
