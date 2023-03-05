import 'package:client_app/models/cdn_image.dart';

class Profile {
  final CdnImage photo;
  final bool isLandlord;
  final String name;
  final String id;
  final String contactNo;

  Profile({
    required this.photo,
    required this.isLandlord,
    required this.name,
    required this.id,
    required this.contactNo,
  });

  // from firebase document
  factory Profile.fromDocument(Map<String, dynamic> data) {
    return Profile(
      photo: CdnImage.fromDocument(data['photo']),
      isLandlord: data['isLandlord'],
      name: data['name'],
      id: data['id'],
      contactNo: data['contactNo'],
    );
  }

  // to firebase document
  Map<String, dynamic> toDocument() {
    return {
      'photo': photo.toDocument(),
      'isLandlord': isLandlord,
      'name': name,
      'id': id,
      'contactNo': contactNo,
    };
  }
}
