import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart'; // Import your app color palette

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // List of icons to animate in the center (simulate loading)
  final List<IconData> _animalIcons = [
    Icons.pets,
    Icons.favorite,
    Icons.pets,
    Icons.access_alarm, // You can replace or add custom icons here
  ];

  // List of advices/tips to display at the bottom
  final List<String> _advices = [
    "Adopt, don't shop!",
    "Give a shelter animal a second chance.",
    "Every paw counts.",
    "Your new best friend is waiting for you.",
    "Open your heart, adopt a pet.",
  ];

  int _currentIconIndex = 0; // Track which icon is currently displayed
  late Timer _iconTimer; // Timer for cycling icons
  late String _advice; // Advice/tip shown at the bottom

  @override
  void initState() {
    super.initState();

    // Pick a random advice to display at the bottom
    _advice = _advices[Random().nextInt(_advices.length)];

    // Change the icon every 600 milliseconds to create a loading animation effect
    _iconTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _currentIconIndex = (_currentIconIndex + 1) % _animalIcons.length;
      });
    });

    // Simulate a loading screen for 3 seconds, then navigate to the Login screen
    Future.delayed(const Duration(seconds: 5), () {
      _iconTimer.cancel(); // Stop the icon animation
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _iconTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use your custom background color from the app palette
      backgroundColor: AppColors.lightBlueWhite,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Spacer for top padding
            const SizedBox(height: 80),
            // Animated animal icon (centered, simulating loading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.lightPeach,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softGreen.withValues(
                        alpha: 102,
                      ), // 40% opacity
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _animalIcons[_currentIconIndex],
                  size: 96,
                  color: AppColors.deepGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App name (brand)
            Text(
              "Hope & Paws",
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: AppColors.terracotta,
                letterSpacing: 4,
              ),
            ),
            // Spacer to push the advice to the bottom
            const Spacer(),
            // Advice or tip shown at the bottom of the screen
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                _advice,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: AppColors.deepGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
