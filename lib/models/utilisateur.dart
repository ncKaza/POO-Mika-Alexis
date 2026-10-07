class Utilisateur {
  final int idUtilisateur;
  final String email;
  final String pseudo;
  final String role;

  Utilisateur({
    required this.idUtilisateur,
    required this.email,
    required this.pseudo,
    required this.role,
  });

  /// Vrai si l'utilisateur a les droits d'administration.
  bool get estAdmin => role == 'ADMIN';

  /// Le mot de passe n'apparaît pas ici : l'API ne le renvoie jamais,
  /// même sous forme hachée.
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      idUtilisateur: int.parse(json['id_utilisateur'].toString()),
      email: json['email'] as String,
      pseudo: json['pseudo'] as String,
      role: json['role'] as String? ?? 'MEMBRE',
    );
  }
}
