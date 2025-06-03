import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/adoption_request.dart';

// Fetches all adoption requests for a user, and attaches animalName to each one
Future<List<AdoptionRequest>> fetchAdoptionRequests(
  String userId,
  String bearerToken,
) async {
  final url = Uri.parse(
    'http://10.0.2.2:7105/api/adoptionrequest/user/$userId',
  );
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $bearerToken'},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    // Parse AdoptionRequest objects
    List<AdoptionRequest> requests = data
        .map((json) => AdoptionRequest.fromJson(json))
        .toList();

    // Build a new list with animalName fetched for each request
    List<AdoptionRequest> requestsWithName = [];
    for (var req in requests) {
      final animalName = await fetchAnimalName(req.animalId, bearerToken);
      requestsWithName.add(req.copyWith(animalName: animalName));
    }

    return requestsWithName;
  } else if (response.statusCode == 404) {
    // No adoption requests for this user
    return [];
  } else {
    throw Exception('Error al obtener las solicitudes de adopción');
  }
}

// Fetches animal name by animalId from backend
Future<String?> fetchAnimalName(String animalId, String bearerToken) async {
  final url = Uri.parse('http://10.0.2.2:7105/api/animal/$animalId');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $bearerToken'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['animalName'];
  } else {
    return null;
  }
}

/// Sends a new adoption request to the backend
Future<void> sendAdoptionRequest({
  required String userId,
  required String animalId,
  required String message,
  required String bearerToken,
}) async {
  final url = Uri.parse('http://10.0.2.2:7105/api/adoptionrequest');
  final body = jsonEncode({
    'userId': userId,
    'animalId': animalId,
    'requestMessage': message,
  });

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode == 201) {
    // Request created successfully
    return;
  } else if (response.statusCode == 400) {
    throw Exception(
      'Solicitud inválida. Revisa los campos e intenta de nuevo.',
    );
  } else {
    throw Exception('Error al enviar la solicitud de adopción.');
  }
}
