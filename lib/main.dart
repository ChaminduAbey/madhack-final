import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/firestore_fetch_service.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/screens/login_screen.dart';
import 'package:client_app/ui/screens/signup_screen.dart';
import 'package:client_app/ui/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreFetchService>(
      () => FirestoreFetchService());
}

final getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.routeName,
      navigatorKey: navigatorKey,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
