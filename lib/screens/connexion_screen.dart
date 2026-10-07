import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_colors.dart';

/// Écran unique pour la connexion et l'inscription : un bouton en bas bascule
/// d'un mode à l'autre, ce qui évite de dupliquer le formulaire.
class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _cleFormulaire = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _emailController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _motDePasseController = TextEditingController();

  bool _modeInscription = false;
  bool _enCours = false;
  String? _messageErreur;

  @override
  void dispose() {
    _emailController.dispose();
    _pseudoController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    // Lance les validator de chaque champ ; on s'arrête si l'un échoue.
    if (!_cleFormulaire.currentState!.validate()) return;

    setState(() {
      _enCours = true;
      _messageErreur = null;
    });

    try {
      final utilisateur = _modeInscription
          ? await _apiService.inscrire(
              email: _emailController.text.trim(),
              pseudo: _pseudoController.text.trim(),
              motDePasse: _motDePasseController.text,
            )
          : await _apiService.connecter(
              email: _emailController.text.trim(),
              motDePasse: _motDePasseController.text,
            );

      Session.ouvrir(utilisateur);

      // L'écran a pu être fermé pendant l'attente réseau : on vérifie avant
      // de toucher au contexte.
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messageErreur = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeInscription ? 'Créer un compte' : 'Connexion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _cleFormulaire,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo_transparent.png', height: 110),
              const SizedBox(height: 32),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (valeur) {
                  if (valeur == null || valeur.trim().isEmpty) {
                    return 'Entrez votre email';
                  }
                  if (!valeur.contains('@') || !valeur.contains('.')) {
                    return 'Adresse email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Le pseudo n'existe qu'à l'inscription.
              if (_modeInscription) ...[
                TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(
                    labelText: 'Pseudo',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valeur) {
                    if (valeur == null || valeur.trim().isEmpty) {
                      return 'Choisissez un pseudo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _motDePasseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (valeur) {
                  if (valeur == null || valeur.isEmpty) {
                    return 'Entrez votre mot de passe';
                  }
                  if (_modeInscription && valeur.length < 6) {
                    return 'Au moins 6 caractères';
                  }
                  return null;
                },
              ),

              if (_messageErreur != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.corail.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.corail),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _messageErreur!,
                          style: const TextStyle(color: AppColors.corail),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enCours ? null : _valider,
                child: _enCours
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_modeInscription ? 'Créer mon compte' : 'Se connecter'),
              ),

              const SizedBox(height: 8),
              TextButton(
                onPressed: _enCours
                    ? null
                    : () => setState(() {
                          _modeInscription = !_modeInscription;
                          _messageErreur = null;
                        }),
                child: Text(
                  _modeInscription
                      ? 'J\'ai déjà un compte'
                      : 'Créer un compte',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
