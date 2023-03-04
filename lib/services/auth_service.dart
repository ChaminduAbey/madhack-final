import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exceptions/no_authenticated_exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getFBUser() {
    if (_auth.currentUser == null) {
      throw NotAuthenticatedException();
    }

    return _auth.currentUser!;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['profile', 'email'],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e, s) {
      rethrow;
    }
  }
}
