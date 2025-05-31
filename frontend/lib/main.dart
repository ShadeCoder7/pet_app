import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart'; // Import your app's main widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- Necesario para inicializar plugins antes de runApp
  await Firebase.initializeApp();
  runApp(const HopePawsApp());
}
