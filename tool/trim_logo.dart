// Outil ponctuel : découpe la bordure noire de LOGO.png et arrondit les coins
// pour obtenir un PNG à fond transparent.
//
//   dart run tool/trim_logo.dart
//
// Lit assets/images/LOGO.png, écrit assets/images/logo_transparent.png.

import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Luminance en dessous de laquelle un pixel est considéré comme faisant
/// partie de la bordure noire, et non du logo. La bordure est du noir pur
/// (0), le point le plus sombre du logo est autour de 11.
const seuil = 5.0;

void main() {
  final source = File('assets/images/LOGO.png');
  if (!source.existsSync()) {
    stderr.writeln('Introuvable : ${source.path}');
    exit(1);
  }

  final original = img.decodePng(source.readAsBytesSync());
  if (original == null) {
    stderr.writeln('PNG illisible');
    exit(1);
  }

  double luminance(int x, int y) {
    final p = original.getPixel(x, y);
    return 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
  }

  // 1. Repérer la zone occupée par le logo.
  var minX = original.width, maxX = -1, minY = original.height, maxY = -1;
  for (var y = 0; y < original.height; y++) {
    for (var x = 0; x < original.width; x++) {
      if (luminance(x, y) <= seuil) continue;
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }
  }
  if (maxX <= minX || maxY <= minY) {
    stderr.writeln('Aucune forme détectée');
    exit(1);
  }

  final largeur = maxX - minX + 1;
  final hauteur = maxY - minY + 1;
  stdout.writeln('Zone détectée : x=$minX y=$minY ${largeur}x$hauteur');

  // 2. Déduire le rayon des coins : le bord gauche droit d'un rectangle
  // arrondi démarre à y = haut + rayon. On sonde deux pixels vers l'intérieur
  // pour éviter l'anticrénelage du bord lui-même.
  var rayon = 0;
  for (var y = 0; y < hauteur; y++) {
    if (luminance(minX + 2, minY + y) > seuil) {
      rayon = y;
      break;
    }
  }
  if (rayon < 2) rayon = (math.min(largeur, hauteur) * 0.22).round();
  stdout.writeln('Rayon des coins : $rayon px');

  // 3. Découper, puis effacer ce qui dépasse du rectangle arrondi.
  final decoupe = img.copyCrop(
    original,
    x: minX,
    y: minY,
    width: largeur,
    height: hauteur,
  ).convert(numChannels: 4);

  final r = rayon.toDouble();
  for (var y = 0; y < hauteur; y++) {
    for (var x = 0; x < largeur; x++) {
      // Centre du cercle du coin le plus proche.
      final cx = x < r ? r : (x > largeur - r ? largeur - r : x.toDouble());
      final cy = y < r ? r : (y > hauteur - r ? hauteur - r : y.toDouble());
      final d = math.sqrt(math.pow(x + 0.5 - cx, 2) + math.pow(y + 0.5 - cy, 2));

      // Transition douce sur 1 px pour éviter des coins en escalier.
      final couverture = ((r - d) + 0.5).clamp(0.0, 1.0);
      if (couverture >= 1.0) continue;

      final p = decoupe.getPixel(x, y);
      decoupe.setPixelRgba(x, y, p.r, p.g, p.b, (p.a * couverture).round());
    }
  }

  final sortie = File('assets/images/logo_transparent.png');
  sortie.writeAsBytesSync(img.encodePng(decoupe));
  stdout.writeln('Écrit : ${sortie.path} (${largeur}x$hauteur)');
}
