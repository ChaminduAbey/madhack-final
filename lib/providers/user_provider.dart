import 'package:client_app/models/profile.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Profile? _profile;

  Profile get profile => _profile!;

  void setProfile(Profile? profile) {
    _profile = profile;
    notifyListeners();
  }

  List<Profile> _profiles = [];

  List<Profile> get profiles => _profiles;

  void setProfiles(List<Profile> profiles) {
    _profiles = profiles;
    notifyListeners();
  }
}
