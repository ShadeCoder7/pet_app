import 'animal_image.dart';

class Animal {
  final String animalId;
  final String animalName;
  final int? animalAge;
  final String animalGender;
  final String animalBreed;
  final String animalDescription;
  final String animalStatus;
  final DateTime adPostedDate;
  final DateTime adUpdateDate;
  final String animalLocation;
  final double? animalLatitude;
  final double? animalLongitude;
  final bool animalIsVerified;
  final String? userId;
  final String? shelterId;
  final String? fosterHomeId;
  final String animalTypeKey;
  final String animalSizeKey;
  final List<AnimalImage> images;

  Animal({
    required this.animalId,
    required this.animalName,
    this.animalAge,
    required this.animalGender,
    required this.animalBreed,
    required this.animalDescription,
    required this.animalStatus,
    required this.adPostedDate,
    required this.adUpdateDate,
    required this.animalLocation,
    this.animalLatitude,
    this.animalLongitude,
    required this.animalIsVerified,
    this.userId,
    this.shelterId,
    this.fosterHomeId,
    required this.animalTypeKey,
    required this.animalSizeKey,
    this.images = const [],
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      animalId: json['animalId'] ?? '',
      animalName: json['animalName'] ?? '',
      animalAge: json['animalAge'],
      animalGender: json['animalGender'] ?? '',
      animalBreed: json['animalBreed'] ?? '',
      animalDescription: json['animalDescription'] ?? '',
      animalStatus: json['animalStatus'] ?? '',
      adPostedDate: DateTime.parse(json['adPostedDate']),
      adUpdateDate: DateTime.parse(json['adUpdateDate']),
      animalLocation: json['animalLocation'] ?? '',
      animalLatitude: json['animalLatitude'] != null
          ? double.tryParse(json['animalLatitude'].toString())
          : null,
      animalLongitude: json['animalLongitude'] != null
          ? double.tryParse(json['animalLongitude'].toString())
          : null,
      animalIsVerified: json['animalIsVerified'] ?? false,
      userId: json['userId'],
      shelterId: json['shelterId'],
      fosterHomeId: json['fosterHomeId'],
      animalTypeKey: json['animalTypeKey'] ?? '',
      animalSizeKey: json['animalSizeKey'] ?? '',
      images: json['images'] != null
          ? List<AnimalImage>.from(
              json['images'].map((img) => AnimalImage.fromJson(img)),
            )
          : [],
    );
  }
}
