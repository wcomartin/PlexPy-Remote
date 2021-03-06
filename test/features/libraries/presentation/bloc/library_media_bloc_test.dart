import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_media_info.dart';
import 'package:tautulli_remote/features/libraries/presentation/bloc/library_media_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryMediaInfo extends Mock implements GetLibraryMediaInfo {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryMediaBloc bloc;
  MockGetLibraryMediaInfo mockGetLibraryMediaInfo;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetLibraryMediaInfo = MockGetLibraryMediaInfo();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    bloc = LibraryMediaBloc(
      getLibraryMediaInfo: mockGetLibraryMediaInfo,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tSectionId = 53052;
  String imageUrl =
      'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';

  final List<LibraryMedia> tLibraryMediaList = [];
  final List<LibraryMedia> tLibraryMediaListWithImages = [];

  final tLibraryMediaInfoJson = json.decode(fixture('library_media_info.json'));
  tLibraryMediaInfoJson['response']['data']['data'].forEach((item) {
    tLibraryMediaList.add(LibraryMediaModel.fromJson(item));
  });

  for (LibraryMedia item in tLibraryMediaList) {
    tLibraryMediaListWithImages.add(item.copyWith(posterUrl: imageUrl));
  }

  // Sort tLibraryMediaListWithImages to match how the bloc will sort tLibraryMediaList
  if (tLibraryMediaListWithImages.first.mediaType == 'album') {
    tLibraryMediaListWithImages.sort((a, b) => b.year.compareTo(a.year));
  } else if (!['movie', 'show', 'artist']
      .contains(tLibraryMediaListWithImages.first.mediaType)) {
    tLibraryMediaListWithImages
        .sort((a, b) => a.mediaIndex.compareTo(b.mediaIndex));
  }

  void setUpSuccess() {
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
    when(
      mockGetLibraryMediaInfo(
        tautulliId: tTautulliId,
        ratingKey: anyNamed('ratingKey'),
        sectionId: anyNamed('sectionId'),
        length: anyNamed('length'),
        refresh: anyNamed('refresh'),
        timeoutOverride: anyNamed('timeoutOverride'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(tLibraryMediaList));
  }

  test(
    'initialState should be LibraryMediaInitial',
    () async {
      // assert
      expect(bloc.state, LibraryMediaInitial());
    },
  );

  group('LibraryMediaFetched', () {
    test(
      'should get data from GetLibraryMedia use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(
          LibraryMediaFetched(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetLibraryMediaInfo(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            sectionId: anyNamed('sectionId'),
            start: anyNamed('start'),
            length: anyNamed('length'),
            refresh: anyNamed('refresh'),
            timeoutOverride: anyNamed('timeoutOverride'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(mockGetLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
          sectionId: anyNamed('sectionId'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          refresh: anyNamed('refresh'),
          timeoutOverride: anyNamed('timeoutOverride'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
      },
    );

    test(
      'should get data from the ImageUrl use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(
          LibraryMediaFetched(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetImageUrl(
            tautulliId: anyNamed('tautulliId'),
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockGetImageUrl(
            tautulliId: tTautulliId,
            img: anyNamed('img'),
            ratingKey: anyNamed('ratingKey'),
            fallback: anyNamed('fallback'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );

    test(
      'should emit [LibraryMediaSuccess] data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaListWithImages,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFetched(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibraryMediaFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(mockGetLibraryMediaInfo(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
          sectionId: anyNamed('sectionId'),
          length: anyNamed('length'),
          refresh: anyNamed('refresh'),
          timeoutOverride: anyNamed('timeoutOverride'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFetched(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  group('LibraryMediaFullRefresh', () {
    test(
      'should emit [LibraryMediaInProgress] before executing as normal',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibraryMediaInProgress(),
          LibraryMediaSuccess(
            libraryMediaList: tLibraryMediaListWithImages,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryMediaFullRefresh(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
        ));
      },
    );
  });
}
