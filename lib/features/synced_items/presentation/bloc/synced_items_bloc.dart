import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../media/domain/usecases/get_metadata.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/synced_item.dart';
import '../../domain/usecases/get_synced_items.dart';

part 'synced_items_event.dart';
part 'synced_items_state.dart';

List<SyncedItem> _syncedItemsListCache;
String _tautulliIdCache;
int _userIdCache;
SettingsBloc _settingsBlocCache;

class SyncedItemsBloc extends Bloc<SyncedItemsEvent, SyncedItemsState> {
  final GetSyncedItems getSyncedItems;
  final GetMetadata getMetadata;
  final GetImageUrl getImageUrl;
  final Logging logging;

  SyncedItemsBloc({
    @required this.getSyncedItems,
    @required this.getMetadata,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(SyncedItemsInitial(
          tautulliId: _tautulliIdCache,
          userId: _userIdCache,
        ));

  @override
  Stream<SyncedItemsState> mapEventToState(
    SyncedItemsEvent event,
  ) async* {
    if (event is SyncedItemsFetch) {
      _userIdCache = event.userId;
      _settingsBlocCache = event.settingsBloc;

      yield* _fetchSyncedItems(
        tautulliId: event.tautulliId,
        userId: event.userId,
        useCachedList: true,
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
    if (event is SyncedItemsFilter) {
      yield SyncedItemsInitial();
      _userIdCache = event.userId;

      yield* _fetchSyncedItems(
        tautulliId: event.tautulliId,
        userId: event.userId,
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<SyncedItemsState> _fetchSyncedItems({
    @required String tautulliId,
    int userId,
    bool useCachedList = false,
    @required SettingsBloc settingsBloc,
  }) async* {
    if (useCachedList &&
        _syncedItemsListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield SyncedItemsSuccess(
        list: _syncedItemsListCache,
      );
    } else {
      final syncedItemsListOrFailure = await getSyncedItems(
        tautulliId: tautulliId,
        userId: userId,
        settingsBloc: settingsBloc,
      );

      yield* syncedItemsListOrFailure.fold(
        (failure) async* {
          logging.error(
            'SyncedItems: Failed to load synced item',
          );

          yield SyncedItemsFailure(
            failure: failure,
            message: FailureMapperHelper.mapFailureToMessage(failure),
            suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
          );
        },
        (list) async* {
          List<SyncedItem> updatedList = await _getImages(
            list: list,
            tautulliId: tautulliId,
            settingsBloc: settingsBloc,
          );

          _syncedItemsListCache = updatedList;

          yield SyncedItemsSuccess(
            list: updatedList,
          );
        },
      );
    }
  }

  Future<List<SyncedItem>> _getImages({
    @required List<SyncedItem> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<SyncedItem> updatedList = [];

    for (SyncedItem syncedItem in list) {
      final String mediaType = syncedItem.syncMediaType ?? syncedItem.mediaType;
      int grandparentRatingKey;
      String grandparentThumb;
      int parentRatingKey;
      String parentThumb;
      int ratingKey = syncedItem.ratingKey;
      String thumb;

      String posterUrl;

      // If item uses parent or grandparent info for poster then use GetMetadata to fetch correct thumb/rating key
      if (['episode', 'track'].contains(mediaType)) {
        final failureOrMetadata = await getMetadata(
          tautulliId: tautulliId,
          syncId: syncedItem.syncId,
          settingsBloc: settingsBloc,
        );

        failureOrMetadata.fold(
          (failure) {
            logging.error(
              'Statistics: Failed to load metadata for ${syncedItem.syncTitle}',
            );
          },
          (item) {
            grandparentRatingKey = item.grandparentRatingKey;
            grandparentThumb = item.grandparentThumb;
            parentRatingKey = item.parentRatingKey;
            parentThumb = item.parentThumb;
            ratingKey = item.ratingKey;
            thumb = item.thumb;
          },
        );
      }

      //* Fetch and assign image URLs
      String posterImg;
      int posterRatingKey;
      String posterFallback;

      // Assign values for poster URL
      switch (mediaType) {
        case ('movie'):
          posterImg = thumb;
          posterRatingKey = ratingKey;
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterImg = grandparentThumb;
          posterRatingKey = grandparentRatingKey;
          posterFallback = 'poster';
          break;
        case ('season'):
          posterImg = parentThumb;
          posterRatingKey = ratingKey;
          posterFallback = 'poster';
          break;
        case ('track'):
          posterImg = thumb;
          posterRatingKey = parentRatingKey;
          posterFallback = 'cover';
          break;
        case ('playlist'):
          posterImg = '/playlists/$ratingKey/composite/69420';
          posterFallback = 'cover';
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey ?? ratingKey,
        fallback: posterFallback,
        settingsBloc: settingsBloc,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'Statistics: Failed to load poster for rating key ${posterRatingKey ?? ratingKey}',
          );
        },
        (url) {
          posterUrl = url;
        },
      );

      updatedList.add(syncedItem.copyWith(posterUrl: posterUrl));
    }

    return updatedList;
  }
}

void clearCache() {
  _syncedItemsListCache = null;
  _tautulliIdCache = null;
  _userIdCache = null;
}
