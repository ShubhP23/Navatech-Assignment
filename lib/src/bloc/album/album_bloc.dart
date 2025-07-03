import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech/src/data/repository/photo_repository.dart';

import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final PhotoRepository repository;

  AlbumBloc({required this.repository}) : super(AlbumInitial()) {
    on<LoadAlbums>((event, emit) async {
      emit(AlbumLoading());
      try {
        final albums = await repository.getAlbums();

        print('Loaded ${albums.length} albums');

        emit(AlbumLoaded(albums));
      } catch (e) {
        emit(AlbumError('Failed to load albums'));
      }
    });
  }
}
