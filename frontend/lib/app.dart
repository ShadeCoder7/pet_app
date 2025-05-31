import 'package:flutter/material.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/menu/main_menu_screen.dart';
import 'screens/animal/animal_list_screen.dart';
import 'screens/animal/animal_profile_screen.dart';
import 'screens/animal/add_animal_screen.dart';
import 'screens/user/public_profile_screen.dart';
import 'screens/options/options_menu_screen.dart';
import 'screens/reports/reports_menu_screen.dart';
import 'screens/requests/requests_menu_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      // Set the initial route (entry screen when the app launches)
      initialRoute: '/onboarding',
      // Map each route to its corresponding screen widget
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainMenuScreen(),
        '/animal-list': (context) => AnimalListScreen(),
        '/animal-profile': (context) => AnimalProfileScreen(),
        '/add-animal': (context) => AddAnimalScreen(),
        '/public-profile': (context) => PublicProfileScreen(),
        '/options': (context) => OptionsMenuScreen(),
        '/reports': (context) => ReportsMenuScreen(),
        '/requests': (context) => RequestsMenuScreen(),
      },
      // Set a base theme for the app (customize as needed)
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
