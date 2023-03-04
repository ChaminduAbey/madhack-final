import 'package:client_app/models/profile.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Profile? _profile;

  Profile get profile => _profile!;

  void setProfile(Profile? profile) {
    _profile = profile;
    notifyListeners();
  }
}
