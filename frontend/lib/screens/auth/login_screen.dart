import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // Import http to call custom backend
import 'dart:convert'; // Import convert to decode JSON
import '../../utils/app_colors.dart';
import '/screens/menu/main_menu_screen.dart'; // Import MainMenuScreen to navigate after login

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  /// Method to fetch the user’s first name from your backend,
  /// using the same route as SessionCheckScreen: GET /api/user/firebase/{uid}
  Future<String?> _fetchUserNameFromBackend(String uid) async {
    // NOTE: On the Android emulator, “localhost” does not work;
    // so we use “10.0.2.2” to point to the host machine.
    final Uri url = Uri.parse('http://10.0.2.2:7105/api/user/firebase/$uid');

    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Your backend returns “userFirstName”
        final String? firstName = data['userFirstName'] as String?;
        // We ignore lastName now, because we only want to show firstName
        if (firstName != null && firstName.isNotEmpty) {
          return firstName;
        }
        // If “userFirstName” does not exist or is empty, consider profile incomplete
        return null;
      } else if (response.statusCode == 404) {
        // The endpoint did not find a record with that UID.
        return null;
      } else {
        // Any other server error.
        return null;
      }
    } catch (e) {
      // Network error or JSON parsing error; return null to force profile completion.
      return null;
    }
  }

  // Method to handle login using Firebase Auth
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Basic validation before calling Firebase
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage("Los campos no pueden estar vacíos.");
      return;
    }

    try {
      // Sign in with email and password using Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Get the currently signed-in user
      final User? user = userCredential.user;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage("No se pudo obtener la información del usuario.");
        return;
      }

      // Fetch user's name from custom backend using UID
      final String? nombreUsuario = await _fetchUserNameFromBackend(user.uid);

      if (!mounted) return;

      if (nombreUsuario == null || nombreUsuario.isEmpty) {
        // If name is not in backend, redirect to CompleteProfileScreen
        Navigator.pushReplacementNamed(context, '/complete-profile');
      } else {
        // Navigate to MainMenuScreen, passing the fetched userName
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: nombreUsuario,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Custom messages for common Firebase errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _showErrorMessage("Email o contraseña incorrectos.");
      } else if (e.code == 'invalid-email') {
        _showErrorMessage("El email introducido no tiene un formato válido.");
      } else {
        _showErrorMessage(
          "Ha fallado el inicio de sesión. Inténtalo de nuevo.",
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage("Ocurrió un error inesperado. Inténtalo de nuevo.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Padding values for logo and login form
    final double logoTopPadding = -30;
    final double formTopPadding = 300;

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo at the top, centered
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
            // Login form
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
                          "Cada huella cuenta.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.deepGreen,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Email input field
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
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password input field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: AppColors.deepGreen),
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
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
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Login button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
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
                                      'Iniciar sesión',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.softGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Go to Register button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿No tienes cuenta?",
                              style: TextStyle(
                                color: AppColors.deepGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                );
                              },
                              child: Text(
                                "Regístrate",
                                style: TextStyle(
                                  color: AppColors.terracotta,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Display error message if any
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
