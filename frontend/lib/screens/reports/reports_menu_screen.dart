import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ReportsMenuScreen extends StatelessWidget {
  const ReportsMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor:
            AppColors.deepGreen, // Use primary color for consistency
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Reportes', // Visible text in Spanish for the user
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
                'Selecciona un reporte', // Visible text in Spanish for the user
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Placeholder content when no reports are available yet
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.report_problem_outlined,
                        color: AppColors.terracotta,
                        size: 80,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no hay reportes disponibles.', // Visible text in Spanish
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
              // (Later you can list report types or past reports here)
            ],
          ),
        ),
      ),
    );
  }
}
