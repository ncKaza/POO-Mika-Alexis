class Categorie {
  final int idCategorie;
  final String libelle;
  final String? icone;

  Categorie({
    required this.idCategorie,
    required this.libelle,
    this.icone,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      idCategorie: int.parse(json['id_categorie'].toString()),
      libelle: json['libelle'] as String,
      icone: json['icone'] as String?,
    );
  }
}
