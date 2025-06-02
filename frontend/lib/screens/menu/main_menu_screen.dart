import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';

class MainMenuScreen extends StatefulWidget {
  final String userName;

  const MainMenuScreen({Key? key, required this.userName}) : super(key: key);

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

  // Fetch all animals from the backend and shuffle for featured selection
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
        // Show 4 to 6 animals at random (adjust as needed)
        _allAnimals = animals.take(6).toList();
      });
    } else {
      // Handle error, show empty list or snackbar if needed
      setState(() => _allAnimals = []);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
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
            fontSize: 26,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/options');
            },
            tooltip: 'Ajustes',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User greeting below the AppBar
            Padding(
              padding: const EdgeInsets.only(
                top: 22,
                left: 24,
                right: 24,
                bottom: 2,
              ),
              child: Center(
                child: Text(
                  'Hola, ${widget.userName}',
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
              child: Divider(thickness: 1.3, color: AppColors.softGreen),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nuestros Peluditos',
                    style: TextStyle(
                      color: AppColors.terracotta,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/animal-list',
                        arguments: widget.userName,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.deepGreen,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
            ),
            // Featured animals grid
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _allAnimals.isEmpty
                  ? Center(child: Text('No hay animales para mostrar'))
                  : GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 14,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      childAspectRatio: 0.92,
                      children: _allAnimals
                          .map((animal) => _AnimalCard(animal: animal))
                          .toList(),
                    ),
            ),
            _MainMenuNavigationBar(userName: widget.userName),
          ],
        ),
      ),
    );
  }
}

// Animal card with real animal info from API
class _AnimalCard extends StatelessWidget {
  final Animal animal;
  const _AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    // Find main image or first image, or null
    AnimalImage? mainImage = animal.images.isNotEmpty
        ? (animal.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => animal.images[0],
          ))
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Navigate to animal profile screen
          Navigator.pushNamed(context, '/animal-profile', arguments: animal);
        },
        splashColor: AppColors.deepGreen,
        child: Card(
          elevation: 5,
          shadowColor: AppColors.deepGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: AppColors.softGreen,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animal photo with placeholder if not available
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: mainImage != null
                      ? Image.network(
                          mainImage.imageUrl,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.pets,
                            size: 56,
                            color: AppColors.deepGreen,
                          ),
                        )
                      : Icon(Icons.pets, size: 56, color: AppColors.deepGreen),
                ),
                const SizedBox(height: 12),
                // Animal name
                Text(
                  animal.animalName,
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom navigation bar widget (igual que antes)
class _MainMenuNavigationBar extends StatelessWidget {
  final String userName;
  const _MainMenuNavigationBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Favoritos button
          IconButton(
            icon: Icon(
              Icons.favorite_outline,
              color: AppColors.terracotta,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
            tooltip: 'Favoritos',
          ),
          // Solicitudes button
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: AppColors.deepGreen,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/requests');
            },
            tooltip: 'Solicitudes',
          ),
          // Central adopt button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 10),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.pets, color: Colors.white, size: 36),
              onPressed: () {
                Navigator.pushNamed(context, '/adopt', arguments: userName);
              },
              tooltip: 'Adoptar',
            ),
          ),
          // Reportes button
          IconButton(
            icon: Icon(
              Icons.report_problem_outlined,
              color: AppColors.terracotta,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/reports');
            },
            tooltip: 'Reportes',
          ),
          // Perfil button
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.deepGreen,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/public-profile');
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
