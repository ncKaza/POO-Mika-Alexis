import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NC EXPLORER 2026"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo_transparent.png",
              height: 150,
            ),
            const Text(
              "NC EXPLORER l'application numéro 1 du Caillou",
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.marine,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Découvrez le Caillou sous tout ses cotés",
              style: TextStyle(
                fontSize: 24,
                color: AppColors.anthracite,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
