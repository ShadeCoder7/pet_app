import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for logout
import '../../utils/app_colors.dart';

class OptionsMenuScreen extends StatelessWidget {
  const OptionsMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite, // Consistent background
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen, // Primary color for header
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ajustes', // Visible text in Spanish
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Profile edit option
            ListTile(
              leading: Icon(Icons.person, color: AppColors.deepGreen),
              title: const Text(
                'Editar perfil', // Visible text in Spanish
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Navigate to public profile or own profile edit screen
                Navigator.pushNamed(context, '/public-profile');
              },
            ),
            Divider(
              color: AppColors.softGreen,
              thickness: 1.2,
              indent: 16,
              endIndent: 16,
            ),
            // Notifications settings option
            ListTile(
              leading: Icon(Icons.notifications, color: AppColors.deepGreen),
              title: const Text(
                'Notificaciones', // Visible text in Spanish
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Placeholder: navigate to notifications settings screen
                // Example: Navigator.pushNamed(context, '/notifications');
              },
            ),
            Divider(
              color: AppColors.softGreen,
              thickness: 1.2,
              indent: 16,
              endIndent: 16,
            ),
            // Logout option with confirmation dialog
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.terracotta),
              title: const Text(
                'Cerrar sesión', // Visible text in Spanish
                style: TextStyle(fontSize: 18, color: AppColors.terracotta),
              ),
              onTap: () {
                // Show confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Confirmar cierre de sesión',
                      ), // Spanish title
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?', // Spanish content
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss dialog
                          },
                          child: const Text('Cancelar'), // Spanish button text
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Dismiss dialog
                            await FirebaseAuth.instance.signOut(); // Sign out
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Cerrar sesión', // Spanish button text
                            style: TextStyle(color: AppColors.terracotta),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(
              color: AppColors.softGreen,
              thickness: 1.2,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ),
    );
  }
}
