import 'package:equatable/equatable.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class LoadPhotos extends PhotoEvent {
  final int albumId;

  const LoadPhotos(this.albumId);

  @override
  List<Object> get props => [albumId];
}
