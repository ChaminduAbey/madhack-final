import 'package:client_app/models/profile.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/ui/views/custom_loading_dialog.dart';

import '../exceptions/not_found_exception.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/signup_screen.dart';

class LoginController {
  Future<void> login() async {
    try {
      CustomLoadingDialog.show(
        navigatorKey.currentContext!,
      );
      await getIt.get<AuthService>().signInWithGoogle();

      final user = getIt.get<AuthService>().getFBUser();

      final Profile profile = await getIt<UserService>().getProfile(
        uid: user.uid,
      );

      getIt.get<UserProvider>().setProfile(profile);

      CustomLoadingDialog.hide(navigatorKey.currentContext!);
      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } on NotFoundException catch (e) {
      CustomLoadingDialog.hide(navigatorKey.currentContext!);
      navigatorKey.currentState!.pushReplacementNamed(SignupScreen.routeName);
    } catch (e) {
      CustomLoadingDialog.hide(navigatorKey.currentContext!);
      rethrow;
    }
  }
}
