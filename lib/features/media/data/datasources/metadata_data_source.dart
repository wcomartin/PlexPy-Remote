import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../../core/error/exception.dart';
import '../../domain/entities/metadata_item.dart';
import '../models/metadata_item_model.dart';

abstract class MetadataDataSource {
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  });
}

class MetadataDataSourceImpl implements MetadataDataSource {
  final tautulliApi.GetMetadata apiGetMetadata;

  MetadataDataSourceImpl({@required this.apiGetMetadata});

  @override
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  }) async {
    final metadataItemJson = await apiGetMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      syncId: syncId,
    );

    Map<String, dynamic> metadataMap = metadataItemJson['response']['data'];

    if (metadataMap.isEmpty) {
      throw MetadataEmptyException;
    } else {
      MetadataItem metadataItem = MetadataItemModel.fromJson(metadataMap);

      return metadataItem;
    }
  }
}