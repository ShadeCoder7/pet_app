import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Controllers for each input field
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _birthDate;
  bool _isLoading = false;
  String? _errorMessage;

  // Function to save the user profile by sending a POST request to the backend
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Basic validation to ensure all required fields are filled
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _birthDate == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Por favor, rellena todos los campos obligatorios.";
      });
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              "Sesión no válida. Por favor, inicia sesión de nuevo.";
        });
        return;
      }

      // Prepare the POST request to save the user profile
      final url = Uri.parse('http://10.0.2.2:7105/api/user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firebaseUid': user.uid,
          'userEmail': user.email,
          'userRole': 'standard',
          'userFirstName': _firstNameController.text.trim(),
          'userLastName': _lastNameController.text.trim(),
          'userPhoneNumber': _phoneController.text.trim(),
          'userAddress': _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          'userBirthDate': _birthDate!.toUtc().toIso8601String(),
          'userProfilePicture': '', // Optional, can be set later
        }),
      );

      // Check the response status and navigate or show error accordingly
      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        setState(() {
          _errorMessage = "Error al guardar el perfil: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de red o servidor. Inténtalo más tarde.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to show the date picker and set the birth date
  Future<void> _pickBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      locale: const Locale('es', ''),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepGreen, // Main background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Completa tu perfil',
                style: TextStyle(
                  color: AppColors.lightBlueWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 36),

              // First name input field
              TextField(
                controller: _firstNameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBlueWhite,
                  hintText: "Nombre",
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: Icon(Icons.person, color: AppColors.softGreen),
                ),
              ),
              const SizedBox(height: 18),

              // Last name input field
              TextField(
                controller: _lastNameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBlueWhite,
                  hintText: "Apellidos",
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: Icon(Icons.badge, color: AppColors.softGreen),
                ),
              ),
              const SizedBox(height: 18),

              // Phone number input field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBlueWhite,
                  hintText: "Teléfono",
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: Icon(Icons.phone, color: AppColors.softGreen),
                ),
              ),
              const SizedBox(height: 18),

              // Birth date input field (using date picker)
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightBlueWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    prefixIcon: Icon(Icons.cake, color: AppColors.softGreen),
                  ),
                  child: Text(
                    _birthDate != null
                        ? "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}"
                        : "Fecha de nacimiento",
                    style: TextStyle(
                      color: _birthDate != null ? Colors.black : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Address input field (optional)
              TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBlueWhite,
                  hintText: "Dirección (opcional)",
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: Icon(Icons.home, color: AppColors.softGreen),
                ),
              ),
              const SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.terracotta,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: AppColors.lightBlueWhite,
                        )
                      : const Text(
                          'Guardar perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Error message (if any)
              // Error message (if any)
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.terracotta,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.terracotta),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: AppColors.terracotta,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
