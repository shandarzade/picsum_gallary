class ImageModel {
  final String id;
  final String downloadUrl;

  ImageModel({required this.id, required this.downloadUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      downloadUrl: json['download_url'],
    );
  }
}
