class Photo {
  final int idPhoto;
  final String url;
  final String? legende;
  final int ordre;

  Photo({
    required this.idPhoto,
    required this.url,
    this.legende,
    required this.ordre,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      idPhoto: int.parse(json['id_photo'].toString()),
      url: json['url'] as String,
      legende: json['legende'] as String?,
      ordre: int.parse(json['ordre'].toString()),
    );
  }
}
