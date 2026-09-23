import 'package:flutter/material.dart';

import '../models/lieu.dart';
import '../services/api_service.dart';

class ListeLieuxScreen extends StatefulWidget {
  const ListeLieuxScreen({super.key});

  @override
  State<ListeLieuxScreen> createState() => _ListeLieuxScreenState();
}

class _ListeLieuxScreenState extends State<ListeLieuxScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Lieu>> _futureLieux;

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
