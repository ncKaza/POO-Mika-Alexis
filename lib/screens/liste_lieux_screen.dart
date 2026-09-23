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
    _futureLieux = _apiService.getLieux();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lieux emblématiques')),
      body: FutureBuilder<List<Lieu>>(
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
    );
  }
}
