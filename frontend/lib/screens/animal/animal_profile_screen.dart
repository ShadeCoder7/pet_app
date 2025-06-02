import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';
import '../../utils/app_colors.dart';

class AnimalProfileScreen extends StatelessWidget {
  final Animal animal;

  const AnimalProfileScreen({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find main image or first one
    AnimalImage? mainImage = animal.images.isNotEmpty
        ? (animal.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => animal.images[0],
          ))
        : null;

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil del Animal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animal Image
                Center(
                  child: mainImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            mainImage.imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.pets,
                          color: AppColors.terracotta,
                          size: 120,
                        ),
                ),
                const SizedBox(height: 22),

                // Animal Name
                Text(
                  animal.animalName,
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Breed, age, and status
                Text(
                  '${animal.animalBreed} | ${animal.animalAge ?? "-"} años',
                  style: TextStyle(
                    color: AppColors.terracotta,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  'Estado: ${animal.animalStatus}',
                  style: TextStyle(color: AppColors.deepGreen, fontSize: 16),
                ),
                const SizedBox(height: 14),

                // Description
                Text(
                  'Descripción',
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  animal.animalDescription,
                  style: TextStyle(color: AppColors.deepGreen, fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Aquí puedes añadir más campos (ubicación, tipo, etc.)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
