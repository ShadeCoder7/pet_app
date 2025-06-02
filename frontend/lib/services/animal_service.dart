import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/animal.dart';

// Service to fetch animals from the API
class AnimalService {
  static const String apiUrl = 'http://10.0.2.2:7105/api/animal';

  // Fetch a random selection of animals (default 4)
  static Future<List<Animal>> fetchRandomAnimals({int count = 4}) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Animal> allAnimals = data
          .map((json) => Animal.fromJson(json))
          .toList();

      // Shuffle and select the first 'count' animals randomly
      allAnimals.shuffle(Random());
      return allAnimals.take(count).toList();
    } else {
      throw Exception('Error loading animals');
    }
  }
}
