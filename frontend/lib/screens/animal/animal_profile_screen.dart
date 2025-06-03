import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';
import '../../utils/app_colors.dart';

class AnimalProfileScreen extends StatelessWidget {
  final Animal animal;

  const AnimalProfileScreen({Key? key, required this.animal}) : super(key: key);

  String _translateValue(String key, Map<String, String> translations) {
    return translations[key.toLowerCase()] ?? key;
  }

  Widget _buildInfoBox(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.deepGreen.withOpacity(0.2),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.terracotta, size: 26),
          const SizedBox(width: 20),
          Text(
            '$label:',
            style: TextStyle(
              color: AppColors.deepGreen,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.deepGreen, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AnimalImage? mainImage = animal.images.isNotEmpty
        ? animal.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => animal.images[0],
          )
        : null;

    final statusTranslations = {
      'available': 'Disponible',
      'adopted': 'Adoptado',
      'pending': 'Pendiente',
      'not_available': 'No disponible',
      'fostered': 'En acogida',
      'in_shelter': 'En refugio',
    };

    final typeTranslations = {'dog': 'Perro', 'cat': 'Gato', 'other': 'Otro'};

    final sizeTranslations = {
      'small': 'Pequeño',
      'medium': 'Mediano',
      'large': 'Grande',
    };

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    : Icon(Icons.pets, color: AppColors.terracotta, size: 120),
              ),
              const SizedBox(height: 20),
              Text(
                animal.animalName,
                style: TextStyle(
                  color: AppColors.deepGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _buildInfoBox(Icons.pets, 'Raza', animal.animalBreed),
              _buildInfoBox(
                Icons.cake_outlined,
                'Edad',
                animal.animalAge != null ? '${animal.animalAge} años' : null,
              ),
              _buildInfoBox(
                Icons.pets_outlined,
                'Tipo',
                _translateValue(
                  animal.animalTypeKey.toLowerCase(),
                  typeTranslations,
                ),
              ),
              _buildInfoBox(
                Icons.straighten,
                'Tamaño',
                _translateValue(
                  animal.animalSizeKey.toLowerCase(),
                  sizeTranslations,
                ),
              ),
              _buildInfoBox(
                Icons.location_on_outlined,
                'Ubicación',
                animal.animalLocation,
              ),
              _buildInfoBox(
                Icons.description_outlined,
                'Descripción',
                animal.animalDescription,
              ),
              _buildInfoBox(
                Icons.info_outline,
                'Estado',
                _translateValue(
                  animal.animalStatus.toLowerCase(),
                  statusTranslations,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
