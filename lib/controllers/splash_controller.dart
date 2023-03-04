import 'dart:developer';

import 'package:client_app/exceptions/no_authenticated_exception.dart';
import 'package:client_app/main.dart';
import 'package:client_app/ui/screens/home_screen.dart';

import '../services/auth_service.dart';
import '../ui/screens/login_screen.dart';

class SplashController {
  Future<void> init() async {
    try {
      await getIt.get<AuthService>().getFBUser();
      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } on NotAuthenticatedException catch (e) {
      navigatorKey.currentState!.pushReplacementNamed(LoginScreen.routeName);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
