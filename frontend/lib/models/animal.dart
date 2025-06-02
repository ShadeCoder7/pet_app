// animal.dart
class Animal {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final int? age;
  final String description;
  final String imageUrl;
  final String status;

  Animal({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.description,
    required this.imageUrl,
    required this.status,
  });

  // animal.dart
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['animalId'],
      name: json['animalName'],
      breed: json['animalBreed'],
      age: json['animalAge'] != null
          ? int.tryParse(json['animalAge'].toString())
          : null,
      gender: json['animalGender'],
      description: json['animalDescription'],
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['imageUrl']
          : '',
      status: json['animalStatus'],
    );
  }
}
