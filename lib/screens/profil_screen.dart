import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 64, color: AppColors.marine),
            SizedBox(height: 16),
            Text(
              'Profil',
              style: TextStyle(fontSize: 18, color: AppColors.anthracite),
            ),
            SizedBox(height: 8),
            Text(
              'Cette section reste à construire.',
              style: TextStyle(color: AppColors.gris),
            ),
          ],
        ),
      ),
    );
  }
}
