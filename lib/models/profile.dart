import 'package:client_app/models/cdn_image.dart';

class Profile {
  final CdnImage photo;
  final bool isLandlord;

  Profile({
    required this.photo,
    required this.isLandlord,
  });

  // from firebase document
  factory Profile.fromDocument(Map<String, dynamic> data) {
    return Profile(
      photo: CdnImage.fromDocument(data['photo']),
      isLandlord: data['isLandlord'],
    );
  }

  // to firebase document
  Map<String, dynamic> toDocument() {
    return {
      'photo': photo.toDocument(),
      'isLandlord': isLandlord,
    };
  }
}
