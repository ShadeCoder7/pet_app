import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../models/animal.dart' as model_animal;

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/session_check_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/menu/main_menu_screen.dart';
import 'screens/favorites/favorites_menu_screen.dart';
import 'screens/requests/adopt_menu_screen.dart';
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
    // Define a map of all named routes and their corresponding builders.
    // We will override '/main' in onGenerateRoute to extract the 'userName' argument.
    final Map<String, WidgetBuilder> routes = {
      '/onboarding': (_) => const OnboardingScreen(),
      '/login': (_) => const LoginScreen(),
      '/register': (_) => const RegisterScreen(),
      '/session-check': (_) => const SessionCheckScreen(),
      '/complete-profile': (_) => const CompleteProfileScreen(),
      '/favorites': (_) => const FavoritesMenuScreen(),
      '/adopt': (_) => const AdoptMenuScreen(),
      // '/main' will be handled in onGenerateRoute to pass userName
      // '/animal-list': (_) => const AnimalListScreen(),
      //'/animal-profile': (_) => const AnimalProfileScreen(),
      '/add-animal': (_) => const AddAnimalScreen(),
      '/public-profile': (_) => const PublicProfileScreen(),
      '/options': (_) => const OptionsMenuScreen(),
      '/reports': (_) => const ReportsMenuScreen(),
      '/requests': (_) => const RequestsMenuScreen(),
    };

    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      // Use onGenerateRoute to apply a global fade transition and handle '/main' dynamically.
      onGenerateRoute: (RouteSettings settings) {
        final String? routeName = settings.name;
        WidgetBuilder? builder;

        if (routeName == '/main') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => MainMenuScreen(userName: args);
          } else {
            builder = (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('No se proporcionó el nombre de usuario.'),
              ),
            );
          }
        } else if (routeName == '/animal-list') {
          final args = settings.arguments;
          if (args is String) {
            builder = (_) => AnimalListScreen(userName: args);
          } else {
            builder = (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('No se proporcionó el nombre de usuario.'),
              ),
            );
          }
        } else if (routeName == '/animal-profile') {
          final args = settings.arguments;
          if (args is model_animal.Animal) {
            builder = (_) => AnimalProfileScreen(animal: args);
          } else {
            builder = (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('No se proporcionó el animal para el perfil.'),
              ),
            );
          }
        } else {
          builder = routes[routeName];
        }

        if (builder == null) {
          // If the route does not exist, show a 404 page in Spanish
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Ruta no encontrada')),
              body: const Center(child: Text('404 - Página no encontrada')),
            ),
          );
        }

        // Wrap each screen in a PageRouteBuilder with a FadeTransition
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
}
