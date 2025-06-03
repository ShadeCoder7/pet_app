import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // Shows the error message and hides it after 3 seconds
  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && errorMessage == message) {
        setState(() {
          errorMessage = null;
        });
      }
    });
  }

  /// Fetch the user's full object from the backend (by Firebase UID)
  Future<Map<String, dynamic>?> fetchUserFromBackend(String uid) async {
    final Uri url = Uri.parse('http://10.0.2.2:7105/api/user/firebase/$uid');
    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Handles login using Firebase Auth
  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Basic validation before calling Firebase
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage("Los campos no pueden estar vacíos.");
      return;
    }

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final User? user = userCredential.user;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        showErrorMessage("No se pudo obtener la información del usuario.");
        return;
      }

      // Get Firebase ID token for authenticated user
      final idToken = await user.getIdToken();

      // Fetch user's full data from backend using Firebase UID
      final userMap = await fetchUserFromBackend(user.uid);

      if (!mounted) return;

      if (userMap == null ||
          userMap['userFirstName'] == null ||
          userMap['userFirstName'].isEmpty) {
        Navigator.pushReplacementNamed(context, '/complete-profile');
      } else {
        final String userFirstName = userMap['userFirstName'];
        final String userGuid =
            userMap['userId']; // <-- THIS is the GUID you need

        // Now pass userName, userId (GUID), and bearerToken to the main menu
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: {
            'userName': userFirstName, // Display name for the user
            'userId': userGuid, // GUID from backend (NOT Firebase UID)
            'bearerToken': idToken, // ID token for backend requests
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showErrorMessage("Email o contraseña incorrectos.");
      } else if (e.code == 'invalid-email') {
        showErrorMessage("El email introducido no tiene un formato válido.");
      } else {
        showErrorMessage("Ha fallado el inicio de sesión. Inténtalo de nuevo.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage("Ocurrió un error inesperado. Inténtalo de nuevo.");
    } finally {
      setState(() {
        isLoading = false;
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
                        // Motivational phrase for users
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
                              onPressed: isLoading ? null : login,
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
                              child: isLoading
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
                        if (errorMessage != null) ...[
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
                                      errorMessage!,
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
