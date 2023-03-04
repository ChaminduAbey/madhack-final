import 'dart:developer';

import 'package:client_app/exceptions/no_authenticated_exception.dart';
import 'package:client_app/exceptions/not_found_exception.dart';
import 'package:client_app/main.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../ui/screens/login_screen.dart';

class SplashController {
  Future<void> init() async {
    try {
      final User user = getIt.get<AuthService>().getFBUser();
      final Profile profile =
          await getIt.get<UserService>().getProfile(uid: user.uid);
      getIt.get<UserProvider>().setProfile(profile);
      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } on NotAuthenticatedException catch (e) {
      navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
    } on NotFoundException catch (e) {
      navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
