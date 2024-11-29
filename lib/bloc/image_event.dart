abstract class ImageEvent {}

class LoadImages extends ImageEvent {
  final int page;
  final int limit;

  LoadImages({required this.page, required this.limit});
}
