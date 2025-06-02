import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// Example animal data for the MVP (replace with API data later)
class Animal {
  final String name;
  final String imageUrl;

  Animal({required this.name, required this.imageUrl});
}

// Main menu screen with professional structure
class MainMenuScreen extends StatelessWidget {
  final String userName;

  const MainMenuScreen({
    Key? key,
    required this.userName, // User name passed from the previous screen
  }) : super(key: key);

  // List of featured animals for demonstration
  List<Animal> get featuredAnimals => [
    Animal(
      name: "Luna",
      imageUrl: "https://loremflickr.com/320/240/dog?lock=1",
    ),
    Animal(name: "Max", imageUrl: "https://loremflickr.com/320/240/cat?lock=2"),
    Animal(
      name: "Simba",
      imageUrl: "https://loremflickr.com/320/240/dog?lock=3",
    ),
    Animal(name: "Mia", imageUrl: "https://loremflickr.com/320/240/cat?lock=4"),
    Animal(
      name: "Rocky",
      imageUrl: "https://loremflickr.com/320/240/dog?lock=5",
    ),
    Animal(
      name: "Lola",
      imageUrl: "https://loremflickr.com/320/240/cat?lock=6",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      // AppBar shows the main menu title
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
                  'Hola, $userName',
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Subtle divider below greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
              child: Divider(thickness: 1.3, color: AppColors.softGreen),
            ),
            // Section header and "Ver todos" button
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
                      // TODO: Navigate to the full animal list screen
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
            // Grid of featured animals (2 per row)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 14,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 2,
                ),
                childAspectRatio: 0.92,
                children: featuredAnimals
                    .map((animal) => _AnimalCard(animal: animal))
                    .toList(),
              ),
            ),
            // Bottom navigation bar with 5 buttons
            _MainMenuNavigationBar(),
          ],
        ),
      ),
    );
  }
}

// Animal card with visual polish and tap effect
class _AnimalCard extends StatelessWidget {
  final Animal animal;
  const _AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: Navigate to the animal details screen if needed
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
                // Animal photo with placeholder if loading/error
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    animal.imageUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.pets, size: 56, color: AppColors.deepGreen),
                  ),
                ),
                const SizedBox(height: 12),
                // Animal name
                Text(
                  animal.name,
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

// Bottom navigation bar widget with 5 icon buttons and Spanish tooltips
// Bottom navigation bar widget with 5 icon buttons and Spanish tooltips
class _MainMenuNavigationBar extends StatelessWidget {
  const _MainMenuNavigationBar();

  @override
  Widget build(BuildContext context) {
    // Helper function to show a quick feedback message
    void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );

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
          // Button for Favoritos screen
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

          // Button for Solicitudes screen
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

          // Central button for Adoptar (animal list) screen
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
                Navigator.pushNamed(context, '/adopt');
              },
              tooltip: 'Adoptar',
            ),
          ),

          // Button for Reportes screen
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

          // Button for Perfil screen
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.deepGreen,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
