import 'photo.dart';

class Lieu {
  final int idLieu;
  final String nom;
  final String? description;
  final double latitude;
  final double longitude;
  final String commune;
  final String province;
  final String? infosPratiques;
  final int idCategorie;
  final String? categorieLibelle;
  final List<Photo> photos;

  Lieu({
    required this.idLieu,
    required this.nom,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.commune,
    required this.province,
    this.infosPratiques,
    required this.idCategorie,
    this.categorieLibelle,
    this.photos = const [],
  });

  // Utilisé pour la liste (GET /api/lieux.php) - pas de photos incluses
  factory Lieu.fromJson(Map<String, dynamic> json) {
    return Lieu(
      idLieu: int.parse(json['id_lieu'].toString()),
      nom: json['nom'] as String,
      description: json['description'] as String?,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      commune: json['commune'] as String,
      province: json['province'] as String,
      infosPratiques: json['infos_pratiques'] as String?,
      idCategorie: int.parse(json['id_categorie'].toString()),
      categorieLibelle: json['categorie_libelle'] as String?,
    );
  }

  // Utilisé pour la fiche détaillée (GET /api/lieux.php?id=X) - inclut les photos
  factory Lieu.fromJsonDetail(Map<String, dynamic> json) {
    final lieu = Lieu.fromJson(json);
    final photosJson = json['photos'] as List<dynamic>? ?? [];
    return Lieu(
      idLieu: lieu.idLieu,
      nom: lieu.nom,
      description: lieu.description,
      latitude: lieu.latitude,
      longitude: lieu.longitude,
      commune: lieu.commune,
      province: lieu.province,
      infosPratiques: lieu.infosPratiques,
      idCategorie: lieu.idCategorie,
      categorieLibelle: lieu.categorieLibelle,
      photos: photosJson
          .map((p) => Photo.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
