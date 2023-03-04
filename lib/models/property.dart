import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/models/faculty_room_time.dart';

class Property {
  final String name;
  final String description;
  final String id;

  final int numberOfBeds;
  final int numberOfBathrooms;
  final int numberOfKitchens;

  final List<CdnImage> images;

  final String address;

  final int price;

  final List<FacultyRoomTime> facultyRoomTimes;

  final String ownerUid;

  Property({
    required this.name,
    required this.description,
    required this.id,
    required this.numberOfBeds,
    required this.numberOfBathrooms,
    required this.numberOfKitchens,
    required this.images,
    required this.price,
    required this.address,
    required this.facultyRoomTimes,
    required this.ownerUid,
  });

  factory Property.fromDocument(Map<String, dynamic> data) {
    return Property(
      name: data['name'],
      description: data['description'],
      id: data['id'],
      numberOfBeds: data['numberOfBeds'],
      numberOfBathrooms: data['numberOfBathrooms'],
      numberOfKitchens: data['numberOfKitchens'],
      images: (data['images'] as List<dynamic>)
          .map((e) => CdnImage.fromDocument(e))
          .toList(),
      price: data['price'],
      address: data['address'],
      facultyRoomTimes: (data['facultyRoomTimes'] as List<dynamic>)
          .map((e) => FacultyRoomTime.fromDocument(e))
          .toList(),
      ownerUid: data['ownerUid'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'description': description,
      'id': id,
      'numberOfBeds': numberOfBeds,
      'numberOfBathrooms': numberOfBathrooms,
      'numberOfKitchens': numberOfKitchens,
      'images': images.map((e) => e.toDocument()).toList(),
      'price': price,
      'address': address,
      'facultyRoomTimes': facultyRoomTimes.map((e) => e.toDocument()).toList(),
      'ownerUid': ownerUid,
    };
  }
}
