import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_users_table.dart';
import 'package:tautulli_remote/features/users/presentation/bloc/users_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUsersTable extends Mock implements GetUsersTable {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  UsersBloc bloc;
  MockGetUsersTable mockGetUsers;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetUsers = MockGetUsersTable();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
    bloc = UsersBloc(
      getUsersTable: mockGetUsers,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';

  final List<UserTable> tUsersList = [];
  final List<UserTable> tUsersList25 = [];

  final userJson = json.decode(fixture('users_table.json'));

  userJson['response']['data']['data'].forEach((item) {
    tUsersList.add(UserTableModel.fromJson(item));
  });

  for (int i = 0; i < 25; i++) {
    userJson['response']['data']['data'].forEach((item) {
      tUsersList25.add(UserTableModel.fromJson(item));
    });
  }

  void setUpSuccess(List list) {
    when(mockGetUsers(
      tautulliId: anyNamed('tautulliId'),
      grouping: anyNamed('grouping'),
      orderColumn: anyNamed('orderColumn'),
      orderDir: anyNamed('orderDir'),
      start: anyNamed('start'),
      length: anyNamed('length'),
      search: anyNamed('search'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(list));
  }

  test(
    'initialState should be UsersInitial',
    () async {
      // assert
      expect(bloc.state, UsersInitial());
    },
  );

  group('UsersFetch', () {
    test(
      'should get data from GetUsersTable use case',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        clearCache();
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetUsers(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetUsers(
            tautulliId: tTautulliId,
            length: 25,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [UsersSuccess] with hasReachedMax as true when data is fetched successfully and the list length is under 25',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        clearCache();
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList,
            hasReachedMax: true,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [UsersSuccess] should emit [UsersSuccess] with hasReachedMax as true when data is fetched successfully and list length under 25',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        clearCache();
        bloc.emit(
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25 + tUsersList,
            hasReachedMax: true,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [UsersSuccess] with hasReachedMax as false when data is fetched successfully and the list length is 25 or more',
      () async {
        // arrange
        setUpSuccess(tUsersList25);
        clearCache();
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'when state is [UsersSuccess] should emit [UsersSuccess] with hasReachedMax as false when data is fetched successfully and list length is 25 or more',
      () async {
        // arrange
        setUpSuccess(tUsersList25);
        clearCache();
        bloc.emit(
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25 + tUsersList25,
            hasReachedMax: false,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [UsersFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        clearCache();
        when(mockGetUsers(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          UsersFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });

  group('UsersFilter', () {
    test(
      'should emit [UsersInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        clearCache();
        // assert later
        final expected = [
          UsersInitial(),
          UsersSuccess(
            list: tUsersList,
            hasReachedMax: true,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UsersFilter(tautulliId: tTautulliId));
      },
    );
  });
}
