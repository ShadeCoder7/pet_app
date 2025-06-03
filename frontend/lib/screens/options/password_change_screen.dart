import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  void _mockChangePassword() async {
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    // Simulate a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      if (_newPasswordController.text == _confirmPasswordController.text &&
          _newPasswordController.text.isNotEmpty) {
        _successMessage = '¡Contraseña cambiada correctamente!';
      } else {
        _errorMessage = 'Las contraseñas no coinciden o están vacías.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        centerTitle: true,
        title: const Text(
          'Cambiar contraseña',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Icon(
                  Icons.lock_reset,
                  color: AppColors.terracotta,
                  size: 60,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Introduce tu contraseña actual y la nueva contraseña.',
                  style: TextStyle(color: AppColors.deepGreen, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Current password field
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña actual',
                  prefixIcon: Icon(Icons.lock, color: AppColors.deepGreen),
                  filled: true,
                  fillColor: AppColors.softGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: AppColors.deepGreen),
                ),
                style: TextStyle(color: AppColors.deepGreen),
              ),
              const SizedBox(height: 18),
              // New password field
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Nueva contraseña',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.terracotta,
                  ),
                  filled: true,
                  fillColor: AppColors.softGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: AppColors.deepGreen),
                ),
                style: TextStyle(color: AppColors.deepGreen),
              ),
              const SizedBox(height: 18),
              // Confirm password field
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirmar contraseña',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.deepGreen,
                  ),
                  filled: true,
                  fillColor: AppColors.softGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: AppColors.deepGreen),
                ),
                style: TextStyle(color: AppColors.deepGreen),
              ),
              const SizedBox(height: 28),

              // Success or error message
              if (_successMessage != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: AppColors.deepGreen),
                        const SizedBox(width: 10),
                        Text(
                          _successMessage!,
                          style: TextStyle(
                            color: AppColors.deepGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_errorMessage != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightPeach,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: AppColors.terracotta),
                        const SizedBox(width: 10),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 22),
              // Change password button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_reset, color: Colors.white),
                  label: const Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isLoading ? null : _mockChangePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
