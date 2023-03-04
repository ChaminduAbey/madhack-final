import 'package:client_app/models/room.dart';
import 'package:client_app/models/university.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  List<University> _universities = [];

  List<University> get universities => _universities;

  void setUniversities(List<University> universities) {
    _universities = universities;
    notifyListeners();
  }

  List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  void setRooms(List<Room> rooms) {
    _rooms = rooms;
    notifyListeners();
  }
}
