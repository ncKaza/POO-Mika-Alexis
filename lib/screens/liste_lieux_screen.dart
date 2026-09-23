import 'package:flutter/material.dart';

import '../models/lieu.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';

class ListeLieuxScreen extends StatefulWidget {
  const ListeLieuxScreen({super.key});

  @override
  State<ListeLieuxScreen> createState() => _ListeLieuxScreenState();
}

class _ListeLieuxScreenState extends State<ListeLieuxScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _rechercheController = TextEditingController();

  late Future<List<Lieu>> _futureLieux;
  late Future<List<Categorie>> _futureCategories;

  String? _provinceSelectionnee;
  int? _idCategorieSelectionnee;

  static const List<String> _provinces = ['Sud', 'Nord', 'Iles Loyaute'];

  @override
  void initState() {
    super.initState();
    _futureCategories = _apiService.getCategories();
    _rechargerLieux();
  }

  void _rechargerLieux() {
    setState(() {
      _futureLieux = _apiService.getLieux(
        recherche: _rechercheController.text,
        province: _provinceSelectionnee,
        idCategorie: _idCategorieSelectionnee,
      );
    });
  }

  void _reinitialiserFiltres() {
    _rechercheController.clear();
    setState(() {
      _provinceSelectionnee = null;
      _idCategorieSelectionnee = null;
    });
    _rechargerLieux();
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lieux emblématiques')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _rechercheController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un lieu...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _rechargerLieux(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _provinceSelectionnee,
                        decoration: const InputDecoration(
                          labelText: 'Province',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Toutes')),
                          ..._provinces.map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          ),
                        ],
                        onChanged: (valeur) {
                          _provinceSelectionnee = valeur;
                          _rechargerLieux();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<List<Categorie>>(
                        future: _futureCategories,
                        builder: (context, snapshot) {
                          final categories = snapshot.data ?? [];
                          return DropdownButtonFormField<int>(
                            initialValue: _idCategorieSelectionnee,
                            decoration: const InputDecoration(
                              labelText: 'Catégorie',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('Toutes')),
                              ...categories.map(
                                (c) => DropdownMenuItem(
                                  value: c.idCategorie,
                                  child: Text(c.libelle),
                                ),
                              ),
                            ],
                            onChanged: (valeur) {
                              _idCategorieSelectionnee = valeur;
                              _rechargerLieux();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _reinitialiserFiltres,
                      icon: const Icon(Icons.clear),
                      label: const Text('Réinitialiser'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _rechargerLieux,
                      icon: const Icon(Icons.search),
                      label: const Text('Rechercher'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Lieu>>(
              future: _futureLieux,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }

                final lieux = snapshot.data ?? [];
                if (lieux.isEmpty) {
                  return const Center(child: Text('Aucun lieu trouvé.'));
                }

                return ListView.builder(
                  itemCount: lieux.length,
                  itemBuilder: (context, index) {
                    final lieu = lieux[index];
                    return ListTile(
                      title: Text(lieu.nom),
                      subtitle: Text('${lieu.categorieLibelle ?? ''} · ${lieu.commune}'),
                      trailing: Text(lieu.province),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
