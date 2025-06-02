import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AddAnimalScreen extends StatelessWidget {
  const AddAnimalScreen({Key? key}) : super(key: key);

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
          'Agregar Animal', // Visible text in Spanish for the user
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
                'Nuevo Peludito', // Visible text in Spanish for the user
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Placeholder for form fields
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pets, color: AppColors.terracotta, size: 80),
                      const SizedBox(height: 12),
                      Text(
                        'Aquí podrás completar el formulario para agregar un nuevo animal.', // Visible text in Spanish
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
              // (Later: add TextFields, Dropdowns, and a submit button to complete the form)
            ],
          ),
        ),
      ),
    );
  }
}
