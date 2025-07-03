import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:navatech/src/data/local/local_storage_service.dart';
import 'package:navatech/src/data/remote/api_service.dart';
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';

class PhotoRepository {
  final ApiService api;
  final LocalStorageService local;

  PhotoRepository({required this.api, required this.local});

  /// Get albums from API; fallback to Hive; fallback to local assets
  Future<List<AlbumModel>> getAlbums() async {
    try {
      print('[Repository] Fetching albums from API');
      final albums = await api.fetchAlbums();
      print('[Repository] Saving ${albums.length} albums to Hive');
      await local.cacheAlbums(albums);
      return albums;
    } catch (_) {
      print('[Repository] API failed, trying cached albums');
      final cached = await local.getCachedAlbums();

      if (cached.isNotEmpty) {
        print('[Repository] Using cached albums');
        return cached;
      }

      print('[Repository] Cache empty, loading albums from assets');
      final json = await rootBundle.loadString('assets/albums.json');
      final List decoded = jsonDecode(json);
      return decoded.map((e) => AlbumModel.fromJson(e)).toList();
    }
  }

  /// Get photos from API; fallback to Hive; fallback to local assets
  Future<List<PhotoModel>> getPhotosByAlbum(int albumId) async {
    try {
      final photos = await api.fetchPhotosByAlbum(albumId);
      await local.cachePhotos(albumId, photos);
      return photos;
    } catch (_) {
      final cached = await local.getCachedPhotos(albumId);

      if (cached.isNotEmpty) {
        print('[Repository] Using cached photos for album $albumId');
        return cached;
      }

      print(
          '[Repository] Cache empty, loading photos_$albumId.json from assets');
      final path = 'assets/photos_$albumId.json';
      final json = await rootBundle.loadString(path);
      final List decoded = jsonDecode(json);
      return decoded.map((e) => PhotoModel.fromJson(e)).toList();
    }
  }
}
