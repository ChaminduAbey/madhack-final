import 'package:client_app/services/user_service.dart';

import '../main.dart';
import '../models/profile.dart';
import '../models/property.dart';
import '../models/university.dart';
import '../providers/room_provider.dart';
import '../providers/user_provider.dart';
import '../services/room_service.dart';

class HomeController {
  Future<void> init() async {
    try {
      await Future.wait([getUniversities(), getRooms(), getProfiles()]);
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> getUniversities() async {
    final List<University> universities =
        await getIt.get<RoomService>().getUniversities();

    getIt.get<RoomProvider>().setUniversities(universities);
  }

  Future<void> getRooms() async {
    final List<Property> rooms = await getIt.get<RoomService>().getProperties();

    getIt.get<RoomProvider>().setRooms(rooms);
  }

  Future<void> getProfiles() async {
    final List<Profile> profiles = await getIt.get<UserService>().getProfiles();

    getIt.get<UserProvider>().setProfiles(profiles);
  }
}
