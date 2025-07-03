import 'package:hive/hive.dart';
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';

class LocalStorageService {
  static const String albumBox = 'album_box';
  static const String photoBox = 'photo_box';

  /// Store album list in Hive (override previous data)
  Future<void> cacheAlbums(List<AlbumModel> albums) async {
    final box = await Hive.openBox<AlbumModel>(albumBox);
    await box.clear(); // Clean stale data
    await box.addAll(albums);
  }

  /// Load cached albums from Hive
  Future<List<AlbumModel>> getCachedAlbums() async {
    final box = await Hive.openBox<AlbumModel>(albumBox);
    return box.values.toList();
  }

  /// Cache photos for a specific album by albumId (keyed by albumId string)
  Future<void> cachePhotos(int albumId, List<PhotoModel> photos) async {
    final box = await Hive.openBox<List<PhotoModel>>(photoBox);
    await box.put(albumId.toString(), photos);
  }

  /// Load cached photos for a given albumId
  Future<List<PhotoModel>> getCachedPhotos(int albumId) async {
    final box = await Hive.openBox<List<PhotoModel>>(photoBox);
    // Return empty list if nothing found
    return box.get(albumId.toString(), defaultValue: []) ?? [];
  }
}
