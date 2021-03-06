import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_children_metadata.dart';
import 'package:tautulli_remote/features/media/presentation/bloc/children_metadata_bloc.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetChildrenMetadata extends Mock implements GetChildrenMetadata {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  ChildrenMetadataBloc bloc;
  MockGetChildrenMetadata mockGetChildrenMetadata;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetChildrenMetadata = MockGetChildrenMetadata();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();

    bloc = ChildrenMetadataBloc(
      getChildrenMetadata: mockGetChildrenMetadata,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tRatingKey = 53052;

  final List<MetadataItem> tChildrenMetadataList = [];

  final tChildrenMetadataJson = json.decode(fixture('children_metadata.json'));
  tChildrenMetadataJson['response']['data']['children_list'].forEach((item) {
    tChildrenMetadataList.add(MetadataItemModel.fromJson(item));
  });

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
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
      mockGetChildrenMetadata(
        tautulliId: tTautulliId,
        ratingKey: anyNamed('ratingKey'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(tChildrenMetadataList));
  }

  test(
    'initialState should be ChildrenMetadataInitial',
    () async {
      // assert
      expect(bloc.state, ChildrenMetadataInitial());
    },
  );

  group('ChildrenMetadataFetched', () {
    test(
      'should get data from GetChildrenMetadata use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(
          ChildrenMetadataFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(mockGetChildrenMetadata(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
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
          ChildrenMetadataFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
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
      'should emit [MetadataFailure] when metadata comes back empty',
      () async {
        // arrange
        final failure = MetadataEmptyFailure();
        when(
          mockGetChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(failure));
        clearCache();
        // assert later
        final expected = [
          ChildrenMetadataInProgress(),
          ChildrenMetadataFailure(
            failure: failure,
            message: METADATA_EMPTY_FAILURE_MESSAGE,
            suggestion: METADATA_EMPTY_FAILURE_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          ChildrenMetadataFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );
  });
}
