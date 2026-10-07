import 'package:flutter/material.dart';

import '../services/session.dart';
import '../theme/app_colors.dart';
import 'connexion_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Future<void> _ouvrirConnexion() async {
    // ConnexionScreen renvoie true quand la connexion a réussi.
    final connecte = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ConnexionScreen()),
    );

    if (connecte == true && mounted) setState(() {});
  }

  void _deconnecter() {
    Session.fermer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Session.estConnecte ? _vueConnecte() : _vueVisiteur(),
        ),
      ),
    );
  }

  Widget _vueVisiteur() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person_outline, size: 64, color: AppColors.marine),
        const SizedBox(height: 16),
        const Text(
          'Vous n\'êtes pas connecté',
          style: TextStyle(fontSize: 18, color: AppColors.anthracite),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connectez-vous pour enregistrer vos lieux favoris.',
          style: TextStyle(color: AppColors.gris),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _ouvrirConnexion,
          icon: const Icon(Icons.login),
          label: const Text('Se connecter'),
        ),
      ],
    );
  }

  Widget _vueConnecte() {
    final utilisateur = Session.utilisateur!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.lagon,
          child: Text(
            // L'initiale du pseudo, en guise d'avatar.
            utilisateur.pseudo.characters.first.toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          utilisateur.pseudo,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.marine,
          ),
        ),
        const SizedBox(height: 4),
        Text(utilisateur.email, style: const TextStyle(color: AppColors.gris)),

        if (utilisateur.estAdmin) ...[
          const SizedBox(height: 12),
          Chip(
            avatar: const Icon(Icons.shield_outlined, size: 18),
            label: const Text('Administrateur'),
            backgroundColor: AppColors.soleil.withValues(alpha: 0.25),
          ),
        ],

        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: _deconnecter,
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
        ),
      ],
    );
  }
}
