import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for logout and account deletion
import '../../utils/app_colors.dart';

class OptionsMenuScreen extends StatelessWidget {
  const OptionsMenuScreen({super.key});

  // Show about dialog
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Hope & Paws',
      applicationVersion: '0.0.1',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo/logo_hope_paws.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      children: const [
        Text('Aplicación para adopción de animales abandonados.'),
        Text('Desarrollada como TFGS por Eric Moya Carmona.'),
      ],
    );
  }

  // Build a menu item with icon and label
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.deepGreen, size: 28),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                color: textColor ?? AppColors.deepGreen,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ajustes',
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
            children: [
              // Main options container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.07 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.deepGreen.withAlpha((0.2 * 255).round()),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  children: [
                    // Notifications settings
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications,
                      label: 'Notificaciones',
                      onTap: () =>
                          Navigator.pushNamed(context, '/notifications'),
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24),

                    // Language settings
                    _buildMenuItem(
                      context,
                      icon: Icons.language,
                      label: 'Idioma',
                      onTap: () {
                        // Show a bottom sheet to change language
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Selecciona el idioma'),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: const Text('Español'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'El idioma se cambiará en una próxima versión.',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: const Text('English'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Language will be available soon.',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24),

                    // Change password
                    _buildMenuItem(
                      context,
                      icon: Icons.lock_reset,
                      label: 'Cambiar contraseña',
                      onTap: () =>
                          Navigator.pushNamed(context, '/change-password'),
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24),

                    // About app
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline,
                      label: 'Acerca de',
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24),

                    // Log out option
                    _buildMenuItem(
                      context,
                      icon: Icons.logout,
                      label: 'Cerrar sesión',
                      iconColor: AppColors.terracotta,
                      textColor: AppColors.terracotta,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar cierre de sesión'),
                            content: const Text(
                              '¿Estás seguro de que deseas cerrar sesión?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  final navigator = Navigator.of(context);
                                  await FirebaseAuth.instance.signOut();
                                  navigator.pushNamedAndRemoveUntil(
                                    '/login',
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(color: AppColors.terracotta),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Delete account container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.07 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.terracotta.withAlpha((0.4 * 255).round()),
                    width: 1.2,
                  ),
                ),
                child: _buildMenuItem(
                  context,
                  icon: Icons.delete_forever,
                  label: 'Eliminar cuenta',
                  iconColor: AppColors.terracotta,
                  textColor: AppColors.terracotta,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar eliminación'),
                        content: const Text(
                          '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción es irreversible.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final navigator = Navigator.of(context);
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );
                              try {
                                await FirebaseAuth.instance.currentUser
                                    ?.delete();
                                navigator.pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              } catch (e) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se pudo eliminar la cuenta.',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(color: AppColors.terracotta),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
