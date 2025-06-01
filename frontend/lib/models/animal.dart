class Animal {
  final String animalId; // ID único (UUID)
  final String animalName; // Nombre del animal
  final int? animalAge; // Edad (opcional)
  final String animalGender; // Género (male/female/not_specified)
  final String animalBreed; // Raza
  final String animalDescription; // Descripción
  final String animalStatus; // Estado (available, adopted, etc.)
  final DateTime adPostedDate; // Fecha publicación anuncio
  final DateTime adUpdateDate; // Fecha última actualización
  final String animalLocation; // Localización descriptiva
  final double? animalLatitude; // Latitud (opcional)
  final double? animalLongitude; // Longitud (opcional)
  final bool animalIsVerified; // Verificado por admin (bool)
  final String?
  animalTypeKey; // Tipo (puedes añadir luego como modelo relacionado)
  final String animalSizeKey; // Tamaño (clave)
  final String? mainImageUrl; // URL de la imagen principal

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

  // Crea un Animal desde un JSON (como el que recibes del backend)
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
      mainImageUrl:
          json['mainImageUrl'], // Ojo: esto debes añadirlo en el DTO/backend si aún no lo tienes.
    );
  }
}
