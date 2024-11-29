import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picsum_gallery/models/image_model.dart';

class ApiService {
  static const String baseUrl = "https://picsum.photos/v2/list";

  Future<List<ImageModel>> fetchImages(int page, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
