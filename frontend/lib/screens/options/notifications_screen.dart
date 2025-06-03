import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _emailsEnabled = true;
  bool _pushEnabled = false;

  // Show a snackbar when the user toggles a switch
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.softGreen,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
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
          'Notificaciones',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepGreen.withAlpha((0.10 * 255).toInt()),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: AppColors.deepGreen.withAlpha((0.2 * 255).toInt()),
                width: 1.1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.terracotta,
                  size: 60,
                ),
                const SizedBox(height: 18),
                Text(
                  '¡Próximamente!',
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aquí podrás gestionar tus notificaciones y alertas sobre adopciones, mensajes y actividad en la app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.terracotta, fontSize: 16),
                ),
                const SizedBox(height: 22),
                // Email notifications switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: AppColors.deepGreen),
                    const SizedBox(width: 10),
                    Text(
                      'Recibir emails',
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Switch(
                      value: _emailsEnabled,
                      activeColor: AppColors.deepGreen,
                      onChanged: (value) {
                        setState(() {
                          _emailsEnabled = value;
                        });
                        _showSnackBar(
                          context,
                          value ? 'Emails activados.' : 'Emails desactivados.',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Push notifications switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_android, color: AppColors.deepGreen),
                    const SizedBox(width: 10),
                    Text(
                      'Notificaciones push',
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Switch(
                      value: _pushEnabled,
                      activeColor: AppColors.deepGreen,
                      onChanged: (value) {
                        setState(() {
                          _pushEnabled = value;
                        });
                        _showSnackBar(
                          context,
                          value
                              ? 'Notificaciones push activadas.'
                              : 'Notificaciones push desactivadas.',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
