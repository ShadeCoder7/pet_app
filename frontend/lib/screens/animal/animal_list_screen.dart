import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';
import 'animal_profile_screen.dart';

class AnimalListScreen extends StatefulWidget {
  final String userName;
  const AnimalListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  // Fetch all animals from the backend for the MVP (no pagination)
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
      // If the request fails, throw an exception (can show a snackbar, too)
      throw Exception('Error cargando animales');
    }
    setState(() => isLoading = false);
  }

  // Get the main image of the animal, or the first one if none is marked as main, or null if no images
  AnimalImage? getMainImage(Animal animal) {
    if (animal.images.isNotEmpty) {
      return animal.images.firstWhere(
        (img) => img.isMainImage,
        orElse: () => animal.images[0],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        centerTitle: true,
        title: const Text(
          'Listado de Animales',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : animals.isEmpty
            ? const Center(child: Text('No hay animales para mostrar'))
            : ListView.builder(
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  Animal animal = animals[index];
                  AnimalImage? mainImage = getMainImage(animal);

                  return Card(
                    child: ListTile(
                      // Show main image if available, or a placeholder
                      leading: CircleAvatar(
                        backgroundImage: mainImage != null
                            ? NetworkImage(mainImage.imageUrl)
                            : const AssetImage(
                                    'assets/images/default_animal.png',
                                  )
                                  as ImageProvider,
                      ),
                      title: Text(animal.animalName),
                      subtitle: Text(
                        animal.animalAge != null
                            ? '${animal.animalBreed} - ${animal.animalAge} años'
                            : animal.animalBreed,
                      ),
                      trailing: Text(animal.animalStatus),
                      // On tap, navigate to the animal's profile, passing the full animal object
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimalProfileScreen(animal: animal),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      // Bottom navigation bar for the list screen
      bottomNavigationBar: AnimalListNavigationBar(userName: widget.userName),
    );
  }
}

// Bottom navigation bar with 5 buttons: Favoritos (center), Inicio, Buscar, Solicitudes, Perfil
class AnimalListNavigationBar extends StatelessWidget {
  final String userName;
  const AnimalListNavigationBar({required this.userName});

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
          // Home button
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.deepGreen,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/main', arguments: userName);
            },
            tooltip: 'Inicio',
          ),
          // Search button
          IconButton(
            icon: Icon(Icons.search, color: AppColors.terracotta, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/buscar');
            },
            tooltip: 'Buscar',
          ),
          // Favorites button (center)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 10),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white, size: 36),
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
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/requests');
            },
            tooltip: 'Solicitudes',
          ),
          // Profile button
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.terracotta,
              size: 28,
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
