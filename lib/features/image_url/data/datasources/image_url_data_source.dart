import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;

abstract class ImageUrlDataSource {
  Future<String> getImage({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  });
}

class ImageUrlDataSourceImpl implements ImageUrlDataSource {
  final tautulliApi.PmsImageProxy apiPmsImageProxy;

  ImageUrlDataSourceImpl({
    @required this.apiPmsImageProxy,
    String img,
    int ratingKey,
    int width,
    int height = 300,
    int opacity,
    int background,
    int blur,
    String fallback,
  });

  @override
  Future<String> getImage({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  }) async {
    final String url = await apiPmsImageProxy(
      tautulliId: tautulliId,
      img: img,
      ratingKey: ratingKey,
      width: width,
      height: height,
      opacity: opacity,
      background: background,
      blur: blur,
      fallback: fallback,
    );

    return url;
  }
}