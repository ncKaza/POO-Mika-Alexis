import 'package:flutter/material.dart';

import 'screens/navigation_principale.dart';
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
      home: const NavigationPrincipale(),
    );
  }
}
