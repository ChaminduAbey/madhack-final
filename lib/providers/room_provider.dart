import 'package:client_app/models/property.dart';
import 'package:client_app/models/university.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  List<University> _universities = [];

  List<University> get universities => _universities;

  void setUniversities(List<University> universities) {
    _universities = universities;
    notifyListeners();
  }

  List<Property> _rooms = [];

  List<Property> get rooms => _rooms;

  void setRooms(List<Property> rooms) {
    _rooms = rooms;
    notifyListeners();
  }
}
