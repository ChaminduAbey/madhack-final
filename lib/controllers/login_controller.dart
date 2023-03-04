import 'package:client_app/models/profile.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/user_service.dart';

import '../exceptions/not_found_exception.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/signup_screen.dart';

class LoginController {
  Future<void> login() async {
    try {
      await getIt.get<AuthService>().signInWithGoogle();

      final user = getIt.get<AuthService>().getFBUser();

      final Profile profile = await getIt<UserService>().getProfile(
        uid: user.uid,
      );

      getIt.get<UserProvider>().setProfile(profile);

      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } on NotFoundException catch (e) {
      navigatorKey.currentState!.pushReplacementNamed(SignupScreen.routeName);
    } catch (e) {
      rethrow;
    }
  }
}
