import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // List of animated icons (center)
  final List<IconData> _animalIcons = [
    Icons.pets_rounded,
    Icons.favorite_rounded,
    Icons.volunteer_activism_rounded,
    Icons.house_sharp,
  ];

  // List of random advices to show at the bottom
  final List<String> _advices = [
    "Cada huella cuenta.",
    "Tu mejor amigo te está esperando.",
    "Un hogar lo cambia todo.",
    "El amor no se compra, se adopta.",
    "Adoptar es un acto de amor.",
    "Un animal rescatado es un alma agradecida.",
    "La adopción es el primer paso hacia un mundo mejor.",
    "La adopción es un acto de valentía y compasión.",
    "Respetar a los animales es una obligación, amarlos es un privilegio.",
  ];

  int _currentIconIndex = 0; // Index of the current icon
  late Timer _iconTimer; // Timer for icon change
  late String _advice; // Current advice shown
  late AnimationController
  _scaleController; // Controls animation (scale & rotation)

  @override
  void initState() {
    super.initState();

    // Select a random advice for the first build
    _advice = _advices[Random().nextInt(_advices.length)];

    // Animation controller for icon scaling and rotation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      lowerBound: 0.90,
      upperBound: 1.06,
    )..repeat(reverse: true);

    // Change the icon every 900ms
    _iconTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      setState(() {
        _currentIconIndex = (_currentIconIndex + 1) % _animalIcons.length;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _iconTimer.cancel();
        // --- FADING NAVIGATION TO LOGIN ---
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _iconTimer.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Padding values for each element (customizable)
    final double logoTopPadding = -50;
    final double iconTopPadding = 120;
    final double iconBottomPadding = 0;
    final double adviceBottomPadding = 40;

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // LOGO at the top (centered)
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
            // ANIMATED ICON in the center
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: iconTopPadding,
                    bottom: iconBottomPadding,
                  ),
                  child: AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleController.value,
                        child: Icon(
                          _animalIcons[_currentIconIndex],
                          size: 160,
                          color: AppColors.deepGreen,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // ADVICE/TIP at the bottom (centered)
            Positioned(
              left: 24,
              right: 24,
              bottom: adviceBottomPadding,
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
