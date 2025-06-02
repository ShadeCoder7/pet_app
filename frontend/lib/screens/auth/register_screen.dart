import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_colors.dart';
import 'login_screen.dart'; // Import LoginScreen widget

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Shows the error message and hides it after 3 seconds
  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _errorMessage == message) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  // Method to register user using Firebase Auth (code comments in English, messages in Spanish)
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Validate email format with a simple regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    // Regex for a strong password: at least 8 characters, upper and lower case, number, and symbol
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );

    // Check if fields are empty
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage("Los campos no pueden estar vacíos.");
      return;
    }

    // Check if email has a valid format
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage("Por favor, introduce un email válido.");
      return;
    }

    // Check if password is strong enough
    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage(
        "La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas, un número y un símbolo.",
      );
      return;
    }

    try {
      // Try to register the user with Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      // Navigate to Session Check Screen with fade transition
      Navigator.pushReplacementNamed(context, '/session-check');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show custom messages for common Firebase errors
      if (e.code == 'email-already-in-use') {
        _showErrorMessage("Este email ya está en uso.");
      } else if (e.code == 'invalid-email') {
        _showErrorMessage("El email introducido no tiene un formato válido.");
      } else if (e.code == 'weak-password') {
        _showErrorMessage("La contraseña es demasiado débil.");
      } else {
        _showErrorMessage("El registro ha fallado. Inténtalo de nuevo.");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Padding values as in LoginScreen
    final double logoTopPadding = -30;
    final double formTopPadding = 300;

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Large logo, top centered
            Positioned(
              top: logoTopPadding,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/logo/logo_hope_paws.png',
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Register form
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: formTopPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 24),
                        // Motivational phrase
                        Text(
                          "Tu mejor amigo te está esperando.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.deepGreen,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Email input
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: AppColors.deepGreen),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelStyle: TextStyle(color: AppColors.deepGreen),
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppColors.deepGreen,
                              ),
                              filled: true,
                              fillColor: AppColors.softGreen,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password input
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: AppColors.deepGreen),
                            decoration: InputDecoration(
                              hintText: 'Contraseña', // Correct hint text
                              labelStyle: TextStyle(color: AppColors.deepGreen),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: AppColors.deepGreen,
                              ),
                              filled: true,
                              fillColor: AppColors.softGreen,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Register button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deepGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.softGreen,
                                      ),
                                    )
                                  : Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.softGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Space before the next section
                        const SizedBox(height: 16),
                        // Go back to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Ya tienes cuenta?",
                              style: TextStyle(
                                color: AppColors.deepGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Fade transition to LoginScreen
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  color: AppColors.terracotta,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Error message with fade-out
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.lightPeach,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.terracotta,
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.terracotta,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: AppColors.terracotta,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
