import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/session_check_screen.dart';
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
    // Define a map of all named routes and their corresponding builders
    final Map<String, WidgetBuilder> routes = {
      '/onboarding': (_) => OnboardingScreen(),
      '/login': (_) => LoginScreen(),
      '/register': (_) => RegisterScreen(),
      '/session-check': (_) => SessionCheckScreen(),
      '/complete-profile': (_) => CompleteProfileScreen(),
      '/main': (_) => MainMenuScreen(),
      '/animal-list': (_) => AnimalListScreen(),
      '/animal-profile': (_) => AnimalProfileScreen(),
      '/add-animal': (_) => AddAnimalScreen(),
      '/public-profile': (_) => PublicProfileScreen(),
      '/options': (_) => OptionsMenuScreen(),
      '/reports': (_) => ReportsMenuScreen(),
      '/requests': (_) => RequestsMenuScreen(),
    };

    return MaterialApp(
      title: 'Hope&Paws',
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      // Remove the `routes:` block and use `onGenerateRoute` to apply a global fade transition
      onGenerateRoute: (RouteSettings settings) {
        final builder = routes[settings.name];
        if (builder == null) {
          // If the route does not exist, display a simple 404 page in Spanish
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
              builder(context),
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
