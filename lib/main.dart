import 'package:client_app/constants/colors.dart';
import 'package:client_app/providers/room_provider.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/firestore_fetch_service.dart';
import 'package:client_app/services/room_service.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/ui/screens/add_room_screen.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/screens/login_screen.dart';
import 'package:client_app/ui/screens/update_profile_screen.dart';
import 'package:client_app/ui/screens/view_property_screen.dart';
import 'package:client_app/ui/screens/signup_screen.dart';
import 'package:client_app/ui/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseChatCore.instance.config = const FirebaseChatCoreConfig(
      null, "firebase-chat/chat/rooms", "firebase-chat/chat/users");

  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreFetchService>(
      () => FirestoreFetchService());

  getIt.registerLazySingleton<UserProvider>(() => UserProvider());
  getIt.registerLazySingleton<RoomProvider>(() => RoomProvider());

  getIt.registerLazySingleton<UserService>(() => UserService(
        firestoreFetchService: getIt(),
      ));
  getIt.registerLazySingleton<RoomService>(() => RoomService(
        firestoreFetchService: getIt(),
      ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<RoomProvider>()),
  ], child: const MyApp()));
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
          useMaterial3: true,
          colorSchemeSeed: primaryColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: scaffoldBGColor,
          appBarTheme: AppBarTheme(backgroundColor: scaffoldBGColor),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: surfaceColor,
          )),
      initialRoute: SplashScreen.routeName,
      navigatorKey: navigatorKey,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        AddRoomScreen.routeName: (context) => const AddRoomScreen(),
        ViewPropertyScreen.routeName: (context) => const ViewPropertyScreen(),
        UpdateProfileScreen.routeName: (context) => const UpdateProfileScreen(),
      },
    );
  }
}
