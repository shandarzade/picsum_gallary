import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picsum_gallery/bloc/image_event.dart';
import 'package:picsum_gallery/bloc/image_state.dart';
import 'package:picsum_gallery/services/api_services.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ApiService apiService;

  ImageBloc({required this.apiService}) : super(ImageInitial());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is LoadImages) {
      if (state is ImageLoading) return;

      try {
        if (state is ImageLoaded && (state as ImageLoaded).hasReachedMax) return;

        yield ImageLoading();
        final images = await apiService.fetchImages(event.page, event.limit);
        final hasReachedMax = images.length < event.limit;

        if (state is ImageLoaded) {
          yield ImageLoaded(
            images: (state as ImageLoaded).images + images,
            hasReachedMax: hasReachedMax,
          );
        } else {
          yield ImageLoaded(images: images, hasReachedMax: hasReachedMax);
        }
      } catch (e) {
        yield ImageError(message: e.toString());
      }
    }
  }
}
