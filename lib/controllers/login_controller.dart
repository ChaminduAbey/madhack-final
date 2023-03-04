import 'package:client_app/api_endpoints.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/services/firestore_fetch_service.dart';

import '../exceptions/not_found_exception.dart';
import '../main.dart';
import '../models/cdn_image.dart';
import '../services/auth_service.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/signup_screen.dart';

class LoginController {
  Future<void> login() async {
    try {
      await getIt.get<AuthService>().signInWithGoogle();

      final user = await getIt.get<AuthService>().getFBUser();

      final Profile profile =
          await getIt.get<FirestoreFetchService>().getDocument<Profile>(
                path: ApiEndpoints.getProfile(uid: user.uid),
                fromDocument: (data) => Profile.fromDocument(data),
              );

      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } on NotFoundException catch (e) {
      navigatorKey.currentState!.pushReplacementNamed(SignupScreen.routeName);
    } catch (e) {
      rethrow;
    }
  }
}
