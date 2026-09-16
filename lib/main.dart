import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("NC EXPLORER 2026"),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "NC EXPLORER l'application numéro 1 du Caillou",
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Poppins'
                ),
                textAlign: TextAlign.center,
              ),
              Text("Découvrez le Caillou sous tout ses cotés ",
              style: TextStyle(
                fontSize: 24
              ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ),
    );
  }
}


