import '../main.dart';
import '../models/property.dart';
import '../models/university.dart';
import '../providers/room_provider.dart';
import '../services/room_service.dart';

class HomeController {
  Future<void> init() async {
    try {
      await Future.wait([
        getUniversities(),
        getRooms(),
      ]);
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
    final List<Property> rooms = await getIt.get<RoomService>().getRooms();

    getIt.get<RoomProvider>().setRooms(rooms);
  }
}
