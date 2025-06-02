class AnimalImage {
  final int animalImageId;
  final String imageUrl;
  final DateTime uploadDate;
  final String? imageAlternativeText;
  final String? imageDescription;
  final bool isMainImage;
  final bool imageIsVerified;
  final String animalId;

  AnimalImage({
    required this.animalImageId,
    required this.imageUrl,
    required this.uploadDate,
    this.imageAlternativeText,
    this.imageDescription,
    required this.isMainImage,
    required this.imageIsVerified,
    required this.animalId,
  });

  factory AnimalImage.fromJson(Map<String, dynamic> json) {
    return AnimalImage(
      animalImageId: json['animalImageId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      uploadDate: DateTime.parse(
        json['uploadDate'] ?? DateTime.now().toIso8601String(),
      ),
      imageAlternativeText: json['imageAlternativeText'],
      imageDescription: json['imageDescription'],
      isMainImage: json['isMainImage'] ?? false,
      imageIsVerified: json['imageIsVerified'] ?? false,
      animalId: json['animalId'] ?? '',
    );
  }
}
