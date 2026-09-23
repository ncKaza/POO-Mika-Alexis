import 'package:flutter/material.dart';

/// Palette officielle de NC Explorer.
///
/// Source : charte graphique v1.0 du 7 septembre 2026, section 7
/// « Codes couleurs (développeurs) ».
class AppColors {
  const AppColors._();

  // --- Couleurs principales (section 2.1) ---

  /// Primaire. Boutons principaux, liens, navigation active.
  static const lagon = Color(0xFF14919B);

  /// Secondaire. Titres, en-têtes, barre de navigation.
  static const marine = Color(0xFF0B2545);

  /// Accent. Appels à l'action secondaires, favoris.
  /// Un seul bouton corail par écran (règle 6).
  static const corail = Color(0xFFE8734A);

  // --- Couleurs thématiques par module (section 2.2) ---

  /// Nature & activités de plein air.
  static const niaouli = Color(0xFF3E7A4E);

  /// Culture & histoire. À réserver aux accents, jamais en aplat de fond.
  static const laterite = Color(0xFFA65131);

  /// Événements, temps forts.
  static const soleil = Color(0xFFF2B134);

  /// Hébergement : hôtels, gîtes, campings.
  static const brunSable = Color(0xFF8A6A45);

  // --- Couleurs neutres (section 2.3) ---

  /// Fond des écrans.
  static const sable = Color(0xFFEFE3CF);

  /// Texte principal.
  static const anthracite = Color(0xFF33363A);

  /// Fond des cartes et zones de contenu.
  static const blancEcume = Color(0xFFFFFFFF);

  /// Légendes et métadonnées (section 3).
  static const gris = Color(0xFF666666);
}
