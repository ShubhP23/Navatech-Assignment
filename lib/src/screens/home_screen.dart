import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech/src/bloc/album/album_bloc.dart';
import 'package:navatech/src/bloc/album/album_event.dart';
import 'package:navatech/src/bloc/album/album_state.dart';
import 'package:navatech/src/data/repository/photo_repository.dart';
import 'package:navatech/src/widgets/photo_row_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load albums when screen initializes
    context.read<AlbumBloc>().add(LoadAlbums());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Albums")),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            final albums = state.albums;

            if (albums.isEmpty) {
              return const Center(child: Text('No albums found'));
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final album = albums[index % albums.length];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        album.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    RepositoryProvider.value(
                      value: context.read<PhotoRepository>(),
                      child: PhotoRowWidget(albumId: album.id),
                    ),
                  ],
                );
              },
              itemCount: 1000000,
              padding: const EdgeInsets.symmetric(vertical: 8),
            );
          } else if (state is AlbumError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
