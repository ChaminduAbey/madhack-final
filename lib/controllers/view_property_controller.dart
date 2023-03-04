import 'package:client_app/main.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/models/property.dart';
import 'package:client_app/services/room_service.dart';
import 'package:client_app/services/user_service.dart';

class ViewPropertyController {
  Future<Profile> getProfile({
    required String userId,
  }) async {
    return getIt.get<UserService>().getProfile(uid: userId);
  }
}
