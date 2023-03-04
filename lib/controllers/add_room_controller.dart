import 'package:client_app/models/room.dart';
import 'package:client_app/models/university.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/cdn_image.dart';
import '../models/faculty_room_time.dart';
import '../providers/room_provider.dart';
import '../services/room_service.dart';

class AddRoomController {
  Future<void> init() async {
    try {
      final List<University> universities =
          await getIt.get<RoomService>().getUniversities();

      getIt.get<RoomProvider>().setUniversities(universities);

      print(universities);
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> addRoom(
      {required String name,
      required String description,
      required String price,
      required String address,
      required int bedsCount,
      required int bathroomsCount,
      required int kitchensCount,
      required List<CdnImage> images,
      required List<FacultyRoomTime> facultyRoomTimes}) async {
    var uuid = const Uuid();

    final Room room = Room(
      name: name,
      description: description,
      id: uuid.v4(),
      numberOfBeds: bedsCount,
      numberOfBathrooms: bathroomsCount,
      numberOfKitchens: kitchensCount,
      images: images,
      facultyRoomTimes: facultyRoomTimes,
      price: int.parse(price),
      address: address,
    );

    await getIt.get<RoomService>().addRoom(room: room);
  }
}
