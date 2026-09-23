import 'package:flutter/material.dart';

import '../models/lieu.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class DetailLieuScreen extends StatefulWidget {
  final int idLieu;

  const DetailLieuScreen({super.key, required this.idLieu});

  @override
  State<DetailLieuScreen> createState() => _DetailLieuScreenState();
}

class _DetailLieuScreenState extends State<DetailLieuScreen> {
  final ApiService _apiService = ApiService();
  late Future<Lieu> _futureLieu;

  @override
  void initState() {
    super.initState();
    _futureLieu = _apiService.getLieuById(widget.idLieu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Lieu>(
        future: _futureLieu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Erreur')),
              body: Center(child: Text('${snapshot.error}')),
            );
          }

          final lieu = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: lieu.photos.isNotEmpty ? 220 : 100,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(lieu.nom),
                  background: lieu.photos.isNotEmpty
                      ? PageView(
                          children: lieu.photos
                              .map(
                                (photo) => Image.network(
                                  photo.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: AppColors.sable,
                                    child: const Icon(Icons.broken_image, size: 48),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Container(color: AppColors.sable),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(label: Text(lieu.categorieLibelle ?? '')),
                          const SizedBox(width: 8),
                          Chip(label: Text(lieu.province)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: AppColors.gris),
                          const SizedBox(width: 4),
                          Text(lieu.commune, style: const TextStyle(color: AppColors.gris)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (lieu.description != null && lieu.description!.isNotEmpty) ...[
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(lieu.description!, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 16),
                      ],
                      if (lieu.infosPratiques != null && lieu.infosPratiques!.isNotEmpty) ...[
                        const Text(
                          'Infos pratiques',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(lieu.infosPratiques!, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 16),
                      ],
                      const Text(
                        'Coordonnées GPS',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${lieu.latitude}, ${lieu.longitude}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
