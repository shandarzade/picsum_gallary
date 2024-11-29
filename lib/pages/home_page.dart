import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picsum_gallery/bloc/image_bloc.dart';
import 'package:picsum_gallery/bloc/image_event.dart';
import 'package:picsum_gallery/bloc/image_state.dart';
// import 'package:picsum_gallery/models/image_model.dart';
import 'package:picsum_gallery/pages/image_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:picsum_gallery/services/api_services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Picsum Gallery')),
      body: BlocProvider(
        create: (context) => ImageBloc(apiService: ApiService())..add(LoadImages(page: 1, limit: 10)),
        child: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            if (state is ImageLoading && state is ImageInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ImageLoaded) {
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification &&
                      scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                    if (!state.hasReachedMax) {
                      BlocProvider.of<ImageBloc>(context).add(LoadImages(page: (state.images.length ~/ 10) + 1, limit: 10));
                    }
                  }
                  return false;
                },
                child: GridView.builder(
                  itemCount: state.images.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == state.images.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final image = state.images[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(imageUrl: image.downloadUrl),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: image.downloadUrl,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ),
              );
            } else if (state is ImageError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
