import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../models/animal.dart' as model_animal;
import '../../models/adoption_request.dart';

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
import 'screens/requests/foster_home_request_screen.dart';
import 'screens/requests/support_animal_request_screen.dart';
import 'screens/options/password_change_screen.dart';
import 'screens/options/notifications_screen.dart';
import 'screens/requests/specific_request_screen.dart';
import 'screens/user/edit_profile_screen.dart';

class HopePawsApp extends StatelessWidget {
  const HopePawsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Static routes (no arguments needed)
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
      '/new-request': (_) => const NewRequestScreen(),
      '/change-password': (_) => const ChangePasswordScreen(),
      '/notifications': (_) => const NotificationsScreen(),
      // Dynamic routes handled below
    };

    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      onGenerateRoute: (RouteSettings settings) {
        final String? routeName = settings.name;
        WidgetBuilder? builder;

        // Main menu (needs userName, userId, bearerToken)
        if (routeName == '/main') {
          final args = settings.arguments;
          if (args is Map &&
              args['userName'] != null &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => MainMenuScreen(
              userName: args['userName'],
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing arguments for the main menu.');
          }
        }
        // Animal list (needs userName, userId, bearerToken)
        else if (routeName == '/animal-list') {
          final args = settings.arguments;
          if (args is Map &&
              args['userName'] != null &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => AnimalListScreen(
              userName: args['userName'],
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) => _errorScreen('Missing arguments for animal list.');
          }
        }
        // Animal profile (needs Animal object)
        else if (routeName == '/animal-profile') {
          final args = settings.arguments;
          if (args is model_animal.Animal) {
            builder = (_) => AnimalProfileScreen(animal: args);
          } else {
            builder = (_) => _errorScreen('No animal provided for profile.');
          }
        }
        // Requests menu (needs userName, userId, bearerToken)
        else if (routeName == '/requests') {
          final args = settings.arguments;
          if (args is Map &&
              args['userName'] != null &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => RequestsMenuScreen(
              userName: args['userName'],
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing arguments for requests menu.');
          }
        }
        // Search animal screen (needs userName, userId, bearerToken)
        else if (routeName == '/search-animal') {
          final args = settings.arguments;
          if (args is Map &&
              args['userName'] != null &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => SearchAnimalScreen(
              userName: args['userName'],
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing arguments for search animal.');
          }
        }
        // Adoption request (needs userId, bearerToken, adoptableAnimals)
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
        // My requests screen (needs userId, bearerToken)
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
        // Specific request detail screen (needs AdoptionRequest object)
        else if (routeName == '/specific-request') {
          final args = settings.arguments;
          if (args is AdoptionRequest) {
            builder = (_) => SpecificRequestScreen(request: args);
          } else {
            builder = (_) => _errorScreen('No request data provided.');
          }
        }
        // Foster Home Request screen (needs userId)
        else if (routeName == '/foster-request') {
          final args = settings.arguments;
          if (args is Map && args['userId'] != null) {
            builder = (_) => FosterHomeRequestScreen(userId: args['userId']);
          } else {
            builder = (_) => const FosterHomeRequestScreen();
          }
        }
        // Support Animal Request screen (needs adoptableAnimals, optionally userId)
        else if (routeName == '/sponsor-request') {
          final args = settings.arguments;
          if (args is Map && args['adoptableAnimals'] != null) {
            builder = (_) => SupportAnimalRequestScreen(
              userId: args['userId'],
              adoptableAnimals: args['adoptableAnimals'],
            );
          } else {
            builder = (_) =>
                _errorScreen('Missing animals for sponsor request.');
          }
        }
        // Edit profile screen (needs User object, userId, bearerToken)
        else if (routeName == '/edit-profile') {
          final args = settings.arguments;
          if (args is Map &&
              args['user'] != null &&
              args['userId'] != null &&
              args['bearerToken'] != null) {
            builder = (_) => EditProfileScreen(
              user: args['user'],
              userId: args['userId'],
              bearerToken: args['bearerToken'],
            );
          } else {
            builder = (_) => _errorScreen('No user data provided for editing.');
          }
        }
        // All other static routes
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
