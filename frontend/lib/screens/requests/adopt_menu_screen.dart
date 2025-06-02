import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AdoptMenuScreen extends StatelessWidget {
  const AdoptMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen, // Use primary color
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Adoptar', // Visible text in Spanish
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section heading
              Text(
                'Solicitar Adopción', // Visible text in Spanish
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Placeholder when there are no adoption requests yet
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pets, color: AppColors.terracotta, size: 80),
                      const SizedBox(height: 12),
                      Text(
                        'Aquí podrás enviar tu solicitud de adopción.',
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
              // (Later: list existing adoption requests or show a form to submit one)
            ],
          ),
        ),
      ),
    );
  }
}
