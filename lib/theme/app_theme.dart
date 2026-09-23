import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Thème global de NC Explorer, construit à partir de la charte graphique v1.0.
class AppTheme {
  const AppTheme._();

  static ThemeData get clair {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lagon,
      brightness: Brightness.light,
      primary: AppColors.lagon,
      onPrimary: Colors.white,
      secondary: AppColors.marine,
      onSecondary: Colors.white,
      tertiary: AppColors.corail,
      onTertiary: Colors.white,
      surface: AppColors.blancEcume,
      onSurface: AppColors.anthracite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Section 2.3 : le sable sert de fond d'écran, le blanc de fond de carte.
      scaffoldBackgroundColor: AppColors.sable,

      // Section 2.1 : le bleu marine porte les en-têtes et la navigation.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.marine,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Section 4.1 : bouton primaire en bleu lagon, texte blanc.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lagon,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Section 4.1 : bouton secondaire en contour bleu marine.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.marine,
          backgroundColor: AppColors.blancEcume,
          side: const BorderSide(color: AppColors.marine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.lagon),
      ),

      // Section 4.3 : cartes blanches, coins arrondis, ombre légère.
      cardTheme: CardThemeData(
        color: AppColors.blancEcume,
        elevation: 2,
        shadowColor: AppColors.marine.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.sable,
        labelStyle: const TextStyle(color: AppColors.anthracite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),

      // Section 2.3 : l'anthracite assure le contraste sur fond sable.
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.anthracite),
        titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.anthracite),
        bodyLarge: TextStyle(color: AppColors.anthracite),
        bodyMedium: TextStyle(color: AppColors.anthracite),
        bodySmall: TextStyle(color: AppColors.gris),
        labelSmall: TextStyle(color: AppColors.gris),
      ),

      iconTheme: const IconThemeData(color: AppColors.marine),
      dividerColor: AppColors.sable,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lagon,
      ),
    );
  }
}
