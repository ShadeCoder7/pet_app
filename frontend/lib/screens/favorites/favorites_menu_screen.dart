import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FavoritesMenuScreen extends StatelessWidget {
  const FavoritesMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor:
            AppColors.deepGreen, // Use same primary color as other main screens
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favoritos', // Visible text in Spanish for the user
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
              // Secondary heading
              Text(
                'Tus Peluditos Favoritos', // Visible text in Spanish for the user
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // If there are no favorites yet, show a placeholder
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: AppColors.terracotta,
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no has agregado ningún favorito.', // Visible text in Spanish
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.deepGreen,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // (Later you can list favorites here in a GridView or ListView)
            ],
          ),
        ),
      ),
    );
  }
}
