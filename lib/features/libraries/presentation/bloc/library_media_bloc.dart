import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../libraries/domain/entities/library_media.dart';
import '../../../libraries/domain/usecases/get_library_media_info.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

part 'library_media_event.dart';
part 'library_media_state.dart';

String _tautulliIdCache;
Map<int, List<LibraryMedia>> _libraryMediaListCache = {};
SettingsBloc _settingsBlocCache;

class LibraryMediaBloc extends Bloc<LibraryMediaEvent, LibraryMediaState> {
  final GetLibraryMediaInfo getLibraryMediaInfo;
  final GetImageUrl getImageUrl;
  final Logging logging;

  LibraryMediaBloc({
    @required this.getLibraryMediaInfo,
    @required this.getImageUrl,
    @required this.logging,
  }) : super(LibraryMediaInitial());

  @override
  Stream<Transition<LibraryMediaEvent, LibraryMediaState>> transformEvents(
    Stream<LibraryMediaEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 25)),
      transitionFn,
    );
  }

  @override
  Stream<LibraryMediaState> mapEventToState(
    LibraryMediaEvent event,
  ) async* {
    if (event is LibraryMediaFetched) {
      _settingsBlocCache = event.settingsBloc;

      if (_tautulliIdCache == event.tautulliId &&
          (_libraryMediaListCache.containsKey(event.ratingKey) ||
              _libraryMediaListCache.containsKey(event.sectionId))) {
        List<LibraryMedia> cachedList = [];
        if (event.ratingKey != null) {
          cachedList = _libraryMediaListCache[event.ratingKey];
        } else if (event.sectionId != null) {
          cachedList = _libraryMediaListCache[event.sectionId];
        }
        yield LibraryMediaSuccess(
          libraryMediaList: cachedList,
        );
      } else {
        yield LibraryMediaInProgress();

        yield* _fetchLibraryMedia(
          tautulliId: event.tautulliId,
          sectionId: event.sectionId,
          ratingKey: event.ratingKey,
          refresh: false,
          settingsBloc: _settingsBlocCache,
        );

        _tautulliIdCache = event.tautulliId;
      }
    }
    if (event is LibraryMediaFullRefresh) {
      yield LibraryMediaInProgress();

      yield* _fetchLibraryMedia(
        tautulliId: event.tautulliId,
        sectionId: event.sectionId,
        ratingKey: event.ratingKey,
        refresh: true,
        timeoutOverride: 10,
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<LibraryMediaState> _fetchLibraryMedia({
    @required String tautulliId,
    @required int ratingKey,
    @required int sectionId,
    @required bool refresh,
    int timeoutOverride,
    @required SettingsBloc settingsBloc,
  }) async* {
    final failureOrLibraryMediaList = await getLibraryMediaInfo(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      sectionId: sectionId,
      length: 100000000000,
      refresh: refresh,
      timeoutOverride: timeoutOverride,
      settingsBloc: settingsBloc,
    );

    yield* failureOrLibraryMediaList.fold(
      (failure) async* {
        logging.error(
          'LibraryMedia: Failed to load items for Section ID $sectionId',
        );

        yield LibraryMediaFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (libraryMediaList) async* {
        final String mediaType = libraryMediaList.first.mediaType;

        await _sortList(
          mediaType: mediaType,
          libraryMediaList: libraryMediaList,
        );

        List<LibraryMedia> updatedList = await _getImages(
          list: libraryMediaList,
          tautulliId: tautulliId,
          settingsBloc: settingsBloc,
        );

        if (ratingKey != null) {
          _libraryMediaListCache[ratingKey] = updatedList;
        } else if (sectionId != null) {
          _libraryMediaListCache[sectionId] = updatedList;
        }

        yield LibraryMediaSuccess(
          libraryMediaList: updatedList,
        );
      },
    );
  }

  Future<void> _sortList({
    @required String mediaType,
    @required List<LibraryMedia> libraryMediaList,
  }) async {
    // Sort by year if album leave sort alone if movie/show/artist
    // and by mediaIndex for everything else
    if (mediaType == 'album') {
      libraryMediaList.sort((a, b) => b.year.compareTo(a.year));
    } else if (!['movie', 'show', 'artist'].contains(mediaType)) {
      libraryMediaList.sort((a, b) => a.mediaIndex.compareTo(b.mediaIndex));
    }
  }

  Future<List<LibraryMedia>> _getImages({
    @required List<LibraryMedia> list,
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    List<LibraryMedia> updatedList = [];

    for (LibraryMedia libraryMediaItem in list) {
      //* Fetch and assign image URLs
      String posterFallback;

      // Assign values for posterFallback
      switch (libraryMediaItem.mediaType) {
        case ('movie'):
        case ('clip'):
          posterFallback = 'poster';
          break;
        case ('episode'):
          posterFallback = 'poster';
          break;
        case ('track'):
          posterFallback = 'cover';
          break;
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: libraryMediaItem.thumb,
        fallback: posterFallback,
        settingsBloc: settingsBloc,
      );
      failureOrPosterUrl.fold(
        (failure) {
          logging.warning(
            'LibraryMedia: Failed to load poster for ${libraryMediaItem.title}',
          );
        },
        (url) {
          updatedList.add(libraryMediaItem.copyWith(posterUrl: url));
        },
      );
    }
    return updatedList;
  }
}

void clearCache() {
  _tautulliIdCache = null;
  _libraryMediaListCache = {};
}
