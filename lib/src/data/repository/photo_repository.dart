import 'package:navatech/src/data/local/local_storage_service.dart';
import 'package:navatech/src/data/remote/api_service.dart';
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';

class PhotoRepository {
  final ApiService api;
  final LocalStorageService local;

  PhotoRepository({required this.api, required this.local});

  /// Get albums from API; fallback to local cache on failure
  Future<List<AlbumModel>> getAlbums() async {
    try {
      final albums = await api.fetchAlbums();
      await local.cacheAlbums(albums); // Save latest data
      return albums;
    } catch (_) {
      // Load offline data if API fails
      return await local.getCachedAlbums();
    }
  }

  /// Get photos by album from API; fallback to cached version on failure
  Future<List<PhotoModel>> getPhotosByAlbum(int albumId) async {
    try {
      final photos = await api.fetchPhotosByAlbum(albumId);
      await local.cachePhotos(albumId, photos);
      return photos;
    } catch (_) {
      return await local.getCachedPhotos(albumId);
    }
  }
}
