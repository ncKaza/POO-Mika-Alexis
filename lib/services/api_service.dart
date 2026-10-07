import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/lieu.dart';
import '../models/categorie.dart';
import '../models/utilisateur.dart';

class ApiService {
  // 10.0.2.2 = adresse de l'ordinateur hôte depuis l'émulateur Android.
  // Sur un appareil physique, remplace par l'IP locale de ton Mac (ex. 192.168.1.X),
  // trouvable avec `ifconfig | grep inet` dans le Terminal.
  // Sur simulateur iOS, localhost fonctionne directement.
  static const String _baseUrl = 'http://10.0.2.2/nc_explorer/php/api';

  // ----------------------------------------------------------
  // Authentification
  // ----------------------------------------------------------

  /// Crée un compte. Le mot de passe part en clair vers le serveur, qui le
  /// hache immédiatement : il n'est jamais stocké tel quel.
  Future<Utilisateur> inscrire({
    required String email,
    required String pseudo,
    required String motDePasse,
  }) async {
    return _appelAuth('inscription', {
      'email': email,
      'pseudo': pseudo,
      'mot_de_passe': motDePasse,
    }, codeAttendu: 201);
  }

  /// Vérifie les identifiants et retourne l'utilisateur correspondant.
  Future<Utilisateur> connecter({
    required String email,
    required String motDePasse,
  }) async {
    return _appelAuth('connexion', {
      'email': email,
      'mot_de_passe': motDePasse,
    }, codeAttendu: 200);
  }

  /// Partie commune aux deux appels : envoi du JSON, puis lecture du message
  /// d'erreur renvoyé par PHP quand le code HTTP n'est pas celui attendu.
  Future<Utilisateur> _appelAuth(
    String action,
    Map<String, String> corps, {
    required int codeAttendu,
  }) async {
    final reponse = await http.post(
      Uri.parse('$_baseUrl/auth.php?action=$action'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(corps),
    );

    final data = jsonDecode(reponse.body) as Map<String, dynamic>;

    if (reponse.statusCode != codeAttendu) {
      throw Exception(data['erreur'] ?? 'Erreur ${reponse.statusCode}');
    }

    return Utilisateur.fromJson(data);
  }

  // ----------------------------------------------------------
  // Catégories
  // ----------------------------------------------------------
  Future<List<Categorie>> getCategories() async {
    final reponse = await http.get(Uri.parse('$_baseUrl/categories.php'));

    if (reponse.statusCode != 200) {
      throw Exception('Erreur lors du chargement des catégories (code ${reponse.statusCode})');
    }

    final List<dynamic> data = jsonDecode(reponse.body);
    return data.map((json) => Categorie.fromJson(json as Map<String, dynamic>)).toList();
  }

  // ----------------------------------------------------------
  // Lieux
  // ----------------------------------------------------------

  /// Liste des lieux, avec filtres optionnels (recherche, province, catégorie)
  Future<List<Lieu>> getLieux({
    String? recherche,
    String? province,
    int? idCategorie,
  }) async {
    final params = <String, String>{};
    if (recherche != null && recherche.isNotEmpty) params['recherche'] = recherche;
    if (province != null && province.isNotEmpty) params['province'] = province;
    if (idCategorie != null) params['id_categorie'] = idCategorie.toString();

    final uri = Uri.parse('$_baseUrl/lieux.php').replace(queryParameters: params);
    final reponse = await http.get(uri);

    if (reponse.statusCode != 200) {
      throw Exception('Erreur lors du chargement des lieux (code ${reponse.statusCode})');
    }

    final List<dynamic> data = jsonDecode(reponse.body);
    return data.map((json) => Lieu.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Détail d'un lieu précis, avec ses photos
  Future<Lieu> getLieuById(int id) async {
    final uri = Uri.parse('$_baseUrl/lieux.php').replace(
      queryParameters: {'id': id.toString()},
    );
    final reponse = await http.get(uri);

    if (reponse.statusCode == 404) {
      throw Exception('Lieu introuvable');
    }
    if (reponse.statusCode != 200) {
      throw Exception('Erreur lors du chargement du lieu (code ${reponse.statusCode})');
    }

    return Lieu.fromJsonDetail(jsonDecode(reponse.body) as Map<String, dynamic>);
  }
}
