import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../models/animal.dart' as model_animal;

// Screens imports
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/session_check_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/menu/main_menu_screen.dart';
import 'screens/favorites/favorites_menu_screen.dart';
import 'screens/animal/animal_list_screen.dart';
import 'screens/animal/animal_profile_screen.dart';
import 'screens/animal/add_animal_screen.dart';
import 'screens/animal/search_animal_screen.dart';
import 'screens/user/public_profile_screen.dart';
import 'screens/options/options_menu_screen.dart';
import 'screens/reports/reports_menu_screen.dart';
import 'screens/requests/requests_menu_screen.dart';
import 'screens/requests/new_request_screen.dart';
import 'screens/requests/adoption_request_screen.dart';
import 'screens/requests/my_requests_screen.dart';

class HopePawsApp extends StatelessWidget {
  const HopePawsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Map of routes that do NOT require custom arguments
    final Map<String, WidgetBuilder> routes = {
      '/onboarding': (_) => const OnboardingScreen(),
      '/login': (_) => const LoginScreen(),
      '/register': (_) => const RegisterScreen(),
      '/session-check': (_) => const SessionCheckScreen(),
      '/complete-profile': (_) => const CompleteProfileScreen(),
      '/favorites': (_) => const FavoritesMenuScreen(),
      '/add-animal': (_) => const AddAnimalScreen(),
      '/public-profile': (_) => const PublicProfileScreen(),
      '/options': (_) => const OptionsMenuScreen(),
      '/reports': (_) => const ReportsMenuScreen(),
      // Request screens with arguments are handled in onGenerateRoute
    };

    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      // onGenerateRoute handles all screens that require custom arguments
      onGenerateRoute: (RouteSettings settings) {
        final String? routeName = settings.name;
        WidgetBuilder? builder;

        // Main menu requires userName argument (String)
        if (routeName == '/main') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => MainMenuScreen(userName: args);
          } else {
            builder = (_) => _errorScreen('No username provided.');
          }
        }
        // Animal list requires userName argument (String)
        else if (routeName == '/animal-list') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => AnimalListScreen(userName: args);
          } else {
            builder = (_) => _errorScreen('No username provided.');
          }
        }
        // Animal profile requires Animal object argument
        else if (routeName == '/animal-profile') {
          final args = settings.arguments;
          if (args is model_animal.Animal) {
            builder = (_) => AnimalProfileScreen(animal: args);
          } else {
            builder = (_) => _errorScreen('No animal provided for profile.');
          }
        }
        // Requests menu requires userName argument (String)
        else if (routeName == '/requests') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => RequestsMenuScreen(userName: args);
          } else {
            builder = (_) => _errorScreen('No username provided.');
          }
        }
        // Search animal screen requires userName argument (String)
        else if (routeName == '/search-animal') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => SearchAnimalScreen(userName: args);
          } else {
            builder = (_) => _errorScreen('No username provided.');
          }
        }
        // New request screen does NOT require arguments
        else if (routeName == '/new-request') {
          builder = (_) => const NewRequestScreen();
        }
        // Adoption request creation screen - requires userId, bearerToken, adoptableAnimals
        else if (routeName == '/adoption-request') {
          final args = settings.arguments;
          if (args is Map &&
              args['userId'] != null &&
              args['bearerToken'] != null &&
              args['adoptableAnimals'] != null) {
            builder = (_) => AdoptionRequestScreen(
              userId: args['userId'],
              bearerToken: args['bearerToken'],
              adoptableAnimals: args['adoptableAnimals'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing arguments for adoption request.');
          }
        }
        // My requests screen - requires userId, bearerToken
        else if (routeName == '/my-requests') {
          final args = settings.arguments;
          if (args is Map &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => MyRequestsScreen(
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing arguments for viewing requests.');
          }
        }
        // All other static routes (from the routes map)
        else {
          builder = routes[routeName];
        }

        // Show 404 error screen if route does not exist
        if (builder == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Route not found')),
              body: const Center(child: Text('404 - Page not found')),
            ),
          );
        }

        // Animate route transitions using a Fade effect
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder!(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
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

  // Helper method to show a user-friendly error screen
  Widget _errorScreen(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
