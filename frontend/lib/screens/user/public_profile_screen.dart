import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBlueWhite, // Use consistent background color
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen, // Primary color for header
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil público', // Visible text in Spanish for the user
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
                'Información del usuario', // Visible text in Spanish for the user
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Placeholder content when no profile data is available yet
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.terracotta,
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aquí podrás ver el perfil público de otros usuarios.', // Visible text in Spanish
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
              // (Later: display actual user profile details or functionality to view/edit public profile)
            ],
          ),
        ),
      ),
    );
  }
}
