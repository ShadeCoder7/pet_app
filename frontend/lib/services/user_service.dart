import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user.dart' as app_user;

// Service to manage user-related API calls
class UserService {
  static const String baseUrl = 'http://10.0.2.2:7105/api/user';

  // Fetches a user by their Firebase UID (automatic token)
  static Future<app_user.User?> fetchUserByFirebaseUid(
    String firebaseUid,
  ) async {
    final String? idToken = await fb_auth.FirebaseAuth.instance.currentUser
        ?.getIdToken();
    if (idToken == null) {
      // User is not authenticated
      return null;
    }
    final Uri url = Uri.parse('$baseUrl/firebase/$firebaseUid');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return app_user.User.fromJson(jsonData);
    } else {
      return null;
    }
  }

  // Fetches a user by their userId (if needed)
  static Future<app_user.User?> fetchUserById(String userId) async {
    final String? idToken = await fb_auth.FirebaseAuth.instance.currentUser
        ?.getIdToken();
    if (idToken == null) {
      return null;
    }
    final Uri url = Uri.parse('$baseUrl/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return app_user.User.fromJson(jsonData);
    } else {
      return null;
    }
  }

  // Updates user profile with PATCH (partial update).
  static Future<void> patchUserProfile(
    String userId,
    Map<String, dynamic> updates,
    String bearerToken,
  ) async {
    final Uri url = Uri.parse('$baseUrl/$userId');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      // Update successful, nothing more to do
      return;
    } else {
      // Handle errors
      throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }
}
