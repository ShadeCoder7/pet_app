import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';
import 'animal_profile_screen.dart';

Map<String, dynamic> getStatusStyle(String? status) {
  switch (status) {
    case 'available':
      return {'label': 'Disponible', 'color': AppColors.deepGreen};
    case 'not_available':
      return {'label': 'No disponible', 'color': Colors.redAccent};
    case 'adopted':
      return {'label': 'Adoptado', 'color': Colors.blueAccent};
    case 'fostered':
      return {'label': 'En acogida', 'color': AppColors.terracotta};
    case 'in_shelter':
      return {'label': 'En refugio', 'color': AppColors.deepGreen};
    default:
      return {'label': 'Desconocido', 'color': Colors.grey};
  }
}

class AnimalListScreen extends StatefulWidget {
  final String userName;
  const AnimalListScreen({super.key, required this.userName});

  @override
  AnimalListScreenState createState() => AnimalListScreenState();
}

class AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  // Fetch all animals from backend for the MVP (no pagination)
  Future<void> fetchAnimals() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse('http://10.0.2.2:7105/api/animal'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        animals = data.map((json) => Animal.fromJson(json)).toList();
      });
    } else {
      setState(() {
        animals = [];
      });
    }
    setState(() => isLoading = false);
  }

  // Returns the main image of the animal, or the first one if none is marked as main
  AnimalImage? getMainImage(Animal animal) {
    if (animal.images.isNotEmpty) {
      return animal.images.firstWhere(
        (img) => img.isMainImage,
        orElse: () => animal.images[0],
      );
    }
    return null;
  }

  Widget _buildAnimalCard(Animal animal) {
    AnimalImage? mainImage = getMainImage(animal);
    final statusInfo = getStatusStyle(animal.animalStatus);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalProfileScreen(animal: animal),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular photo with green border (just like main_menu_screen)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.softGreen, width: 3),
                ),
                child: CircleAvatar(
                  radius: 31,
                  backgroundColor: AppColors.softGreen,
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
                      style: const TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          animal.animalBreed,
                          style: TextStyle(
                            color: AppColors.terracotta,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (animal.animalAge != null) ...[
                          const SizedBox(width: 10),
                          Text(
                            '- ${animal.animalAge} años',
                            style: TextStyle(
                              color: AppColors.terracotta,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    // Status chip (box) with color and text depending on status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusInfo['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        statusInfo['label'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite, // Main app background
      appBar: AppBar(
        backgroundColor: AppColors.terracotta,
        centerTitle: true,
        title: const Text(
          'Nuestros Peluditos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : animals.isEmpty
            ? Center(
                child: Text(
                  'No hay animales para mostrar',
                  style: TextStyle(
                    color: AppColors.terracotta,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: animals.length,
                itemBuilder: (context, index) =>
                    _buildAnimalCard(animals[index]),
              ),
      ),
      // Navigation bar with the same style as other screens
      bottomNavigationBar: AnimalListNavigationBar(userName: widget.userName),
    );
  }
}

// Bottom navigation bar (same style as main menu)
class AnimalListNavigationBar extends StatelessWidget {
  final String userName;
  const AnimalListNavigationBar({super.key, required this.userName});

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
          // Home button
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/main', arguments: userName);
            },
            tooltip: 'Inicio',
          ),
          // Search button
          IconButton(
            icon: Icon(Icons.search, color: AppColors.terracotta, size: 32),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/search-animal',
                arguments: userName,
              );
            },
            tooltip: 'Buscar',
          ),
          // Favorites (central)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 14),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              tooltip: 'Favoritos',
            ),
          ),
          // Requests button
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/requests', arguments: userName);
            },
            tooltip: 'Solicitudes',
          ),
          // Profile button
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.terracotta,
              size: 34,
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
