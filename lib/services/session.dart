import '../models/utilisateur.dart';

/// Garde en mémoire l'utilisateur connecté, le temps que l'application tourne.
///
/// Volontairement minimal : rien n'est écrit sur le téléphone, donc fermer
/// l'application déconnecte. Pour rester connecté entre deux lancements, il
/// faudrait stocker l'identifiant avec le paquet `shared_preferences`.
class Session {
  const Session._();

  static Utilisateur? _utilisateur;

  /// L'utilisateur courant, ou null si personne n'est connecté.
  static Utilisateur? get utilisateur => _utilisateur;

  static bool get estConnecte => _utilisateur != null;

  static void ouvrir(Utilisateur utilisateur) {
    _utilisateur = utilisateur;
  }

  static void fermer() {
    _utilisateur = null;
  }
}
