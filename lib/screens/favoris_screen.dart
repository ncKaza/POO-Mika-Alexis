import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.corail),
            SizedBox(height: 16),
            Text(
              'Aucun favori pour le moment',
              style: TextStyle(fontSize: 18, color: AppColors.anthracite),
            ),
            SizedBox(height: 8),
            Text(
              'Les lieux que vous enregistrez apparaîtront ici.',
              style: TextStyle(color: AppColors.gris),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
