import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetch all albums from the server
  Future<List<AlbumModel>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // Convert each map to AlbumModel
      return data.map((e) => AlbumModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  /// Fetch all photos for a given albumId
  Future<List<PhotoModel>> fetchPhotosByAlbum(int albumId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // Convert each map to PhotoModel
      return data.map((e) => PhotoModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
