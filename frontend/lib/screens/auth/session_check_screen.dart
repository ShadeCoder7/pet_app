import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class SessionCheckScreen extends StatefulWidget {
  const SessionCheckScreen({super.key});

  @override
  State<SessionCheckScreen> createState() => _SessionCheckScreenState();
}

class _SessionCheckScreenState extends State<SessionCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    try {
      // Endpoint of your backend (adapt for emulator if needed)
      final url = Uri.parse(
        'http://10.0.2.2:7105/api/user/firebase/${user.uid}',
      );
      final response = await http.get(url);

      // Check if the widget is still mounted before navigating
      if (!mounted) return;
      if (response.statusCode == 200) {
        // User exists, go to main menu
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // User does not exist, go to complete profile
        Navigator.pushReplacementNamed(context, '/complete-profile');
      }
    } catch (e) {
      // If there's a network error, you might want to show an error or retry
      // For MVP, just send to complete profile to avoid blocking user
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/complete-profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading indicator
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
