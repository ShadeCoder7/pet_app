import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FavoritesMenuScreen extends StatelessWidget {
  const FavoritesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favoritos',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Secondary heading with icon
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.terracotta.withAlpha(
                          (0.10 * 255).toInt(),
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.terracotta.withAlpha(
                        (0.25 * 255).toInt(),
                      ),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pets, color: AppColors.deepGreen, size: 20),
                      const SizedBox(width: 10),
                      // Flexible prevents text overflow
                      Flexible(
                        child: Text(
                          'Peluditos Favoritos',
                          style: TextStyle(
                            color: AppColors.deepGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: AppColors.terracotta.withAlpha(
                                  (0.12 * 255).toInt(),
                                ),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.pets, color: AppColors.deepGreen, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              // Placeholder with improved visuals
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepGreen.withAlpha(
                            (0.07 * 255).toInt(),
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppColors.terracotta.withAlpha(
                                (0.15 * 255).toInt(),
                              ),
                              size: 100,
                            ),
                            Icon(
                              Icons.favorite_border,
                              color: AppColors.terracotta,
                              size: 70,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Aún no has agregado ningún favorito.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.deepGreen,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¡Explora y agrega tus mascotas favoritas aquí!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.deepGreen.withAlpha(
                              (0.7 * 255).toInt(),
                            ),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'Buscar mascotas',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
