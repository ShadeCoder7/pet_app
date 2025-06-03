import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/user_service.dart';
import '../../services/animal_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/animal.dart';

class NewRequestScreen extends StatelessWidget {
  const NewRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of request options
    final List<_RequestOption> options = [
      _RequestOption(
        icon: Icons.pets,
        title: 'Adopción',
        description: 'Solicita la adopción de uno de nuestros animales.',
        color: AppColors.deepGreen,
        route: '/adoption-request',
      ),
      _RequestOption(
        icon: Icons.home_rounded,
        title: 'Casa de Acogida',
        description: 'Ofrece tu hogar como casa de acogida temporal.',
        color: AppColors.softGreen,
        route: '/foster-request',
      ),
      _RequestOption(
        icon: Icons.volunteer_activism,
        title: 'Apadrinar',
        description: 'Ayuda económicamente apadrinando a un animal.',
        color: AppColors.terracotta,
        route: '/sponsor-request',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Nueva Solicitud',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            ...options.map((option) => _RequestCard(option: option)),
          ],
        ),
      ),
    );
  }
}

// Internal model for option
class _RequestOption {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String route;

  _RequestOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.route,
  });
}

// Card widget for each option
class _RequestCard extends StatefulWidget {
  final _RequestOption option;

  const _RequestCard({required this.option});

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  @override
  Widget build(BuildContext context) {
    final option = widget.option;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () async {
          // Handle "Adopción" (adoption request)
          if (option.route == '/adoption-request') {
            final User? firebaseUser = FirebaseAuth.instance.currentUser;
            if (!mounted) return;
            if (firebaseUser == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debes iniciar sesión para adoptar.')),
              );
              return;
            }
            final String firebaseUid = firebaseUser.uid;
            final String bearerToken = (await firebaseUser.getIdToken()) ?? '';

            if (!mounted) return;
            final userApi = await UserService.fetchUserByFirebaseUid(
              firebaseUid,
            );
            if (!mounted) return;
            if (userApi == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No se pudo obtener tu usuario.')),
              );
              return;
            }
            final userId = userApi.userId;

            final List<Animal> adoptableAnimals =
                await AnimalService.fetchRandomAnimals(count: 20);

            if (!mounted) return;
            Navigator.pushNamed(
              context,
              '/adoption-request',
              arguments: {
                'userId': userId,
                'bearerToken': bearerToken,
                'adoptableAnimals': adoptableAnimals,
              },
            );
          }
          // Handle "Apadrinar" (sponsor request)
          else if (option.route == '/sponsor-request') {
            final User? firebaseUser = FirebaseAuth.instance.currentUser;
            if (!mounted) return;
            if (firebaseUser == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Debes iniciar sesión para apadrinar.')),
              );
              return;
            }
            final String firebaseUid = firebaseUser.uid;

            // Optionally, fetch user from backend if you want userId (like adoption)
            final userApi = await UserService.fetchUserByFirebaseUid(
              firebaseUid,
            );
            if (!mounted) return;
            if (userApi == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No se pudo obtener tu usuario.')),
              );
              return;
            }
            final userId = userApi.userId;

            // Fetch list of animals to sponsor (can be same as adoptable)
            final List<Animal> adoptableAnimals =
                await AnimalService.fetchRandomAnimals(count: 20);

            if (!mounted) return;
            Navigator.pushNamed(
              context,
              '/sponsor-request',
              arguments: {
                'userId': userId,
                'adoptableAnimals': adoptableAnimals,
              },
            );
          }
          // All other routes (no arguments needed)
          else {
            if (!mounted) return;
            Navigator.pushNamed(context, option.route);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: option.color.withAlpha((0.14 * 255).round()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: option.color.withAlpha((0.28 * 255).round()),
              width: 1.3,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.color.withAlpha((0.18 * 255).round()),
                ),
                padding: const EdgeInsets.all(13),
                child: Icon(option.icon, color: option.color, size: 36),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: option.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16.3,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black45, size: 34),
            ],
          ),
        ),
      ),
    );
  }
}
