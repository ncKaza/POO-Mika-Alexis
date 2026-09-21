import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NC Explorer",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5E9D7),
      ),
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
            SvgPicture.asset(
              "assets/images/NC_EXPLORER_logo.svg",
              height: 150,
            ),
            const Text(
              "NC EXPLORER l'application numéro 1 du Caillou",
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Découvrez le Caillou sous tout ses cotés",
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () => debugPrint("clickez ici"),
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