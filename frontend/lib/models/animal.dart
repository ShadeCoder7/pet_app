class Animal {
  final String animalId; // Unique identifier (UUID)
  final String animalName; // Name of the animal
  final int? animalAge; // Age (optional)
  final String animalGender; // Gender (male/female/not_specified)
  final String animalBreed; // Breed
  final String animalDescription; // Description
  final String animalStatus; // Status (available, adopted, etc.)
  final DateTime adPostedDate; // Advertisement posted date
  final DateTime adUpdateDate; // Advertisement last updated date
  final String animalLocation; // Descriptive location
  final double? animalLatitude; // Latitude (optional)
  final double? animalLongitude; // Longitude (optional)
  final bool animalIsVerified; // Verified by admin (bool)
  final String?
  animalTypeKey; // Type key (can be linked to related model later)
  final String animalSizeKey; // Size key
  final String? mainImageUrl; // URL of the main image

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
    this.animalTypeKey,
    required this.animalSizeKey,
    this.mainImageUrl,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      animalId: json['animalId'],
      animalName: json['animalName'],
      animalAge: json['animalAge'],
      animalGender: json['animalGender'],
      animalBreed: json['animalBreed'],
      animalDescription: json['animalDescription'],
      animalStatus: json['animalStatus'],
      adPostedDate: DateTime.parse(json['adPostedDate']),
      adUpdateDate: DateTime.parse(json['adUpdateDate']),
      animalLocation: json['animalLocation'],
      animalLatitude: json['animalLatitude'] != null
          ? double.tryParse(json['animalLatitude'].toString())
          : null,
      animalLongitude: json['animalLongitude'] != null
          ? double.tryParse(json['animalLongitude'].toString())
          : null,
      animalIsVerified: json['animalIsVerified'] ?? false,
      animalTypeKey: json['animalTypeKey'],
      animalSizeKey: json['animalSizeKey'],
      mainImageUrl: json['mainImageUrl'],
    );
  }
}
