import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech/src/bloc/photo/photo_bloc.dart';
import 'package:navatech/src/bloc/photo/photo_event.dart';
import 'package:navatech/src/bloc/photo/photo_state.dart';
import 'package:navatech/src/data/repository/photo_repository.dart';

class PhotoRowWidget extends StatefulWidget {
  final int albumId;

  const PhotoRowWidget({super.key, required this.albumId});

  @override
  State<PhotoRowWidget> createState() => _PhotoRowWidgetState();
}

class _PhotoRowWidgetState extends State<PhotoRowWidget> {
  late final PhotoBloc _photoBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _photoBloc = PhotoBloc(repository: context.read<PhotoRepository>());
    _photoBloc.add(LoadPhotos(widget.albumId));

    // Jump to middle to allow backward scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController
            .jumpTo(50000); // arbitrary offset to fake infinite scroll
      }
    });
  }

  @override
  void dispose() {
    _photoBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  /// Fallback image generator using dummyimage.com
  String _getFallbackUrl(int id) {
    return 'https://dummyimage.com/100x100/000/fff&text=Photo+$id';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BlocBuilder<PhotoBloc, PhotoState>(
        bloc: _photoBloc,
        builder: (context, state) {
          if (state is PhotoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotoLoaded) {
            final photos = state.photos;

            return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final photo = photos[index % photos.length];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.network(
                    photo.thumbnailUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    // Show dummy image on load error
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        _getFallbackUrl(photo.id),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
              },
              itemCount: 1000000, // simulate infinite horizontal scroll
            );
          } else if (state is PhotoError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
