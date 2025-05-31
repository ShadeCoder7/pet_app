import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_colors.dart';
import '../../utils/fade_route.dart'; // Import fade transition helper
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

  // Method to register user using Firebase Auth
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      // Use fade transition to LoginScreen
      Navigator.of(
        context,
      ).pushReplacement(createFadeRoute(const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Padding values as in LoginScreen
    final double logoTopPadding = 10;
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
                  width: 350,
                  height: 350,
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
                                      // Corrected text for the button
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.softGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Error message
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                                Navigator.of(context).pushReplacement(
                                  createFadeRoute(const LoginScreen()),
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
