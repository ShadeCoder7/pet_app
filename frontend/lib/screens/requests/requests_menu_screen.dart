import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class RequestsMenuScreen extends StatefulWidget {
  final String userName;
  final String userId;
  final String bearerToken;

  // RequestsMenuScreen receives userName, userId, and bearerToken for navigation and logic
  const RequestsMenuScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  State<RequestsMenuScreen> createState() => _RequestsMenuScreenState();
}

class _RequestsMenuScreenState extends State<RequestsMenuScreen> {
  double _scaleNewRequest = 1.0;
  double _scaleMyRequests = 1.0;

  // Helper widget for option boxes in the menu
  Widget _buildOptionBox({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double scale,
    required void Function(bool) onPressChanged,
  }) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => onPressChanged(true),
        onTapUp: (_) => onPressChanged(false),
        onTapCancel: () => onPressChanged(false),
        onTap: onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: AppColors.deepGreen.withAlpha((0.3 * 255).round()),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepGreen.withAlpha((0.2 * 255).round()),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 72, color: AppColors.deepGreen),
                  const SizedBox(height: 18),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          'Solicitudes',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué deseas hacer?',
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  _buildOptionBox(
                    context: context,
                    icon: Icons.add_circle_outline,
                    label: 'Nueva solicitud',
                    onTap: () {
                      // Here you should navigate to the "New Request" screen
                      Navigator.pushNamed(
                        context,
                        '/new-request',
                        arguments: {
                          'userId': widget.userId,
                          'bearerToken': widget.bearerToken,
                        },
                      );
                    },
                    scale: _scaleNewRequest,
                    onPressChanged: (pressed) {
                      setState(() {
                        _scaleNewRequest = pressed ? 0.95 : 1.0;
                      });
                    },
                  ),
                  _buildOptionBox(
                    context: context,
                    icon: Icons.list_alt_outlined,
                    label: 'Mis solicitudes',
                    onTap: () {
                      // Navigate to "My Requests" with userId and bearerToken
                      Navigator.pushNamed(
                        context,
                        '/my-requests',
                        arguments: {
                          'userId': widget.userId,
                          'bearerToken': widget.bearerToken,
                        },
                      );
                    },
                    scale: _scaleMyRequests,
                    onPressChanged: (pressed) {
                      setState(() {
                        _scaleMyRequests = pressed ? 0.95 : 1.0;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RequestsMenuBottomNavBar(
        userName: widget.userName,
        userId: widget.userId,
        bearerToken: widget.bearerToken,
      ),
    );
  }
}

// Bottom navigation bar now receives and uses all user arguments
class RequestsMenuBottomNavBar extends StatelessWidget {
  final String userName;
  final String userId;
  final String bearerToken;

  const RequestsMenuBottomNavBar({
    super.key,
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.15 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Inicio
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () {
              // Go to main menu, passing all arguments
              Navigator.pushNamed(
                context,
                '/main',
                arguments: {
                  'userName': userName,
                  'userId': userId,
                  'bearerToken': bearerToken,
                },
              );
            },
            tooltip: 'Inicio',
          ),
          // Buscar
          IconButton(
            icon: Icon(Icons.search, color: AppColors.terracotta, size: 32),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/search-animal',
                arguments: {
                  'userName': userName,
                  'userId': userId,
                  'bearerToken': bearerToken,
                },
              );
            },
            tooltip: 'Buscar',
          ),
          // Favoritos (central)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 14),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              tooltip: 'Favoritos',
            ),
          ),
          // Reportes
          IconButton(
            icon: Icon(
              Icons.report_problem_outlined,
              color: AppColors.terracotta,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/reports');
            },
            tooltip: 'Reportes',
          ),
          // Perfil
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.deepGreen,
              size: 34,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/public-profile');
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
