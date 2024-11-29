import 'package:picsum_gallery/models/image_model.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<ImageModel> images;
  final bool hasReachedMax;

  ImageLoaded({required this.images, required this.hasReachedMax});
}

class ImageError extends ImageState {
  final String message;

  ImageError({required this.message});
}
