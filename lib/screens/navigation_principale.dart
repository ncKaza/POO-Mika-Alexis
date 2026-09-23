import 'package:flutter/material.dart';

import 'accueil_screen.dart';
import 'favoris_screen.dart';
import 'liste_lieux_screen.dart';
import 'profil_screen.dart';

/// Coque principale de l'application : garde la barre de navigation visible
/// et fait défiler les quatre sections en dessous.
class NavigationPrincipale extends StatefulWidget {
  const NavigationPrincipale({super.key});

  @override
  State<NavigationPrincipale> createState() => _NavigationPrincipaleState();
}

class _NavigationPrincipaleState extends State<NavigationPrincipale> {
  int _indexCourant = 0;

  /// Un IndexedStack conserve l'état de chaque onglet : les filtres de
  /// recherche et la position de défilement survivent au changement d'onglet.
  static const List<Widget> _ecrans = [
    AccueilScreen(),
    ListeLieuxScreen(),
    FavorisScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indexCourant,
        children: _ecrans,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexCourant,
        onDestinationSelected: (index) {
          setState(() => _indexCourant = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Carte',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
