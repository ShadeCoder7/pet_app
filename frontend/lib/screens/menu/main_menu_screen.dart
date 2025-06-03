import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';
import '../../services/user_service.dart';
import '../../services/animal_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class MainMenuScreen extends StatefulWidget {
  final String userName;
  final String userId;
  final String bearerToken;

  // MainMenuScreen requires userName, userId, and bearerToken for correct navigation and security
  const MainMenuScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<Animal> _allAnimals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  // Fetch animal list from backend API
  Future<void> fetchAnimals() async {
    setState(() => _isLoading = true);
    final response = await http.get(
      Uri.parse('http://10.0.2.2:7105/api/animal'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      List<Animal> animals = data.map((json) => Animal.fromJson(json)).toList();
      animals.shuffle(Random());
      setState(() {
        _allAnimals = animals.take(6).toList();
      });
    } else {
      setState(() => _allAnimals = []);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite, // App background color
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Menú principal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.terracotta,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/options');
            },
            tooltip: 'Ajustes',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card with icon and user name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 410),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepGreen.withAlpha((0.11 * 255).round()),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.softGreen.withAlpha((0.35 * 255).round()),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.waving_hand_outlined,
                    color: AppColors.terracotta,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '¡Hola!',
                    style: TextStyle(
                      color: AppColors.terracotta,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 9),
                  // Nombre de usuario flexible y con elipsis si es muy largo
                  Flexible(
                    child: Text(
                      widget.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            20, // Puedes ajustar este valor si lo prefieres más grande/pequeño
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 6),
          ),
          // "Nuestros Peluditos" header with paw icon and all-animals button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.pets, color: AppColors.terracotta, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Nuestros Peluditos',
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/animal-list',
                      arguments: widget.userName,
                    );
                  },
                  icon: Icon(Icons.chevron_right, color: AppColors.deepGreen),
                  label: Text(
                    'Ver todos',
                    style: TextStyle(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                      letterSpacing: 0.1,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.deepGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Animal list (loading, empty, or data)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allAnimals.isEmpty
                ? Center(
                    child: Text(
                      'No hay animales para mostrar',
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    itemCount: _allAnimals.length,
                    itemBuilder: (context, index) {
                      final animal = _allAnimals[index];
                      return _AnimalCard(animal: animal);
                    },
                  ),
          ),
          // Bottom navigation bar receives all necessary arguments for navigation
          _MainMenuNavigationBar(
            userName: widget.userName,
            userId: widget.userId,
            bearerToken: widget.bearerToken,
          ),
        ],
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final Animal animal;
  const _AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    AnimalImage? mainImage = animal.images.isNotEmpty
        ? animal.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => animal.images[0],
          )
        : null;
    // Use the first image as main if no main image is set
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/animal-profile', arguments: animal),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepGreen.withAlpha((0.13 * 255).round()),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animal image with border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.softGreen, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepGreen.withAlpha(
                        (0.15 * 255).round(),
                      ),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.white,
                  backgroundImage: mainImage != null
                      ? NetworkImage(mainImage.imageUrl)
                      : const AssetImage('assets/images/default_animal.png')
                            as ImageProvider,
                ),
              ),
              const SizedBox(width: 18),
              // Animal details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.animalName,
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      animal.animalAge != null
                          ? '${animal.animalBreed} - ${animal.animalAge} ${animal.animalAge == 1 ? 'año' : 'años'}'
                          : animal.animalBreed,
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom navigation bar receives userName, userId, and bearerToken to correctly propagate them when navigating
class _MainMenuNavigationBar extends StatelessWidget {
  final String userName;
  final String userId;
  final String bearerToken;

  const _MainMenuNavigationBar({
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.15 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.favorite_outline,
              color: AppColors.terracotta,
              size: 34,
            ),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
            tooltip: 'Favoritos',
          ),
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              '/requests',
              arguments: {
                'userName': userName,
                'userId': userId,
                'bearerToken': bearerToken,
              },
            ),
            tooltip: 'Solicitudes',
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 14),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.pets, color: Colors.white, size: 40),
              tooltip: 'Adoptar',
              onPressed: () async {
                // Step 1: Get Firebase user and token
                final fb_auth.User? firebaseUser =
                    fb_auth.FirebaseAuth.instance.currentUser;
                if (firebaseUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Debes iniciar sesión para adoptar.'),
                    ),
                  );
                  return;
                }
                final String firebaseUid = firebaseUser.uid;
                final String bearerToken =
                    await firebaseUser.getIdToken() ?? '';

                // Step 2: Get userId from backend using Firebase UID
                final userApi = await UserService.fetchUserByFirebaseUid(
                  firebaseUid,
                );
                if (userApi == null) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo obtener tu usuario.')),
                  );
                  return;
                }
                final userId = userApi
                    .userId; // Adjust if your model uses a different field

                // Step 3: Get adoptable animals (fetchRandomAnimals brings N random animals, change number if needed)
                final adoptableAnimals = await AnimalService.fetchRandomAnimals(
                  count: 20,
                );

                // Step 4: Navigate to adoption request screen with all required arguments
                if (!context.mounted) return;
                Navigator.pushNamed(
                  context,
                  '/adoption-request',
                  arguments: {
                    'userId': userId,
                    'bearerToken': bearerToken,
                    'adoptableAnimals': adoptableAnimals,
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.report_problem_outlined,
              color: AppColors.terracotta,
              size: 32,
            ),
            onPressed: () => Navigator.pushNamed(context, '/reports'),
            tooltip: 'Reportes',
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.deepGreen,
              size: 34,
            ),
            onPressed: () => Navigator.pushNamed(context, '/public-profile'),
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
