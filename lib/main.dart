import 'package:flutter/material.dart';
import 'screens/liste_lieux_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NC Explorer",
      theme: AppTheme.clair,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NC EXPLORER 2026"),
      ),
      body: Center(
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
            const Text(
              "Découvrez le Caillou sous tout ses cotés",
              style: TextStyle(
                fontSize: 24,
                color: AppColors.anthracite,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListeLieuxScreen()),
                );
              },
              child: const Text(
                "Affichez la carte",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}