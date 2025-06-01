import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/menu/main_menu_screen.dart';
import 'screens/animal/animal_list_screen.dart';
import 'screens/animal/animal_profile_screen.dart';
import 'screens/animal/add_animal_screen.dart';
import 'screens/user/public_profile_screen.dart';
import 'screens/options/options_menu_screen.dart';
import 'screens/reports/reports_menu_screen.dart';
import 'screens/requests/requests_menu_screen.dart';

class HopePawsApp extends StatelessWidget {
  const HopePawsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/complete-profile': (context) => CompleteProfileScreen(),
        '/main': (context) => MainMenuScreen(),
        '/animal-list': (context) => AnimalListScreen(),
        '/animal-profile': (context) => AnimalProfileScreen(),
        '/add-animal': (context) => AddAnimalScreen(),
        '/public-profile': (context) => PublicProfileScreen(),
        '/options': (context) => OptionsMenuScreen(),
        '/reports': (context) => ReportsMenuScreen(),
        '/requests': (context) => RequestsMenuScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: const [Locale('es', ''), Locale('en', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
