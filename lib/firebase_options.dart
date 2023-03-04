// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCftAxws-cPZvc2STElOSRySIfqh5kBHk',
    appId: '1:269970761110:android:354ed3e7765acec59e69b7',
    messagingSenderId: '269970761110',
    projectId: 'madhack-final',
    storageBucket: 'madhack-final.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1pFfbBZ8fLc0RBCM3Hbh0YpqZbLd52tI',
    appId: '1:269970761110:ios:1f087c9b7953b5979e69b7',
    messagingSenderId: '269970761110',
    projectId: 'madhack-final',
    storageBucket: 'madhack-final.appspot.com',
    androidClientId: '269970761110-pdeaokut976uhrtbq2tpovkun40rc6k5.apps.googleusercontent.com',
    iosClientId: '269970761110-e19hkpjn3khpc6n7e1ck2rgv3e3ni9oj.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientApp',
  );
}