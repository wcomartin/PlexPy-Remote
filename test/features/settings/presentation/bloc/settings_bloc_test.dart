import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/core/database/domain/entities/server.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/settings_bloc.dart';

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsBloc bloc;
  MockSettings mockSettings;
  MockLogging mockLogging;

  setUp(() {
    mockSettings = MockSettings();
    mockLogging = MockLogging();

    bloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final int tId = 1;
  final String tPrimaryConnectionAddress = 'http://tautulli.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautulli.com';
  final String tPrimaryConnectionUser = null;
  final String tPrimaryConnectionPassword = null;
  final String tSecondaryConnectionAddress = 'http://tautulli.com';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';
  final String tNewPrimaryConnectionAddress = 'https://plexpy.com';
  final String tNewPrimaryConnectionProtocol = 'https';
  final String tNewPrimaryConnectionDomain = 'plexpy.com';
  final String tNewPrimaryConnectionUser = 'user';
  final String tNewPrimaryConnectionPassword = 'pass';
  final String tNewDeviceToken = 'def';
  final String tNewTautulliId = 'mno';
  final String tNewPlexName = 'Plex2';

  final Server tServerModel = ServerModel(
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionProtocol,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionUser: tPrimaryConnectionUser,
    primaryConnectionPassword: tPrimaryConnectionPassword,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
  );

  final List<ServerModel> tServerList = [tServerModel];

  final Server tUpdatedServerModel = ServerModel(
    primaryConnectionAddress: tNewPrimaryConnectionAddress,
    primaryConnectionProtocol: tNewPrimaryConnectionProtocol,
    primaryConnectionDomain: tNewPrimaryConnectionDomain,
    primaryConnectionUser: tNewPrimaryConnectionUser,
    primaryConnectionPassword: tNewPrimaryConnectionPassword,
    deviceToken: tNewDeviceToken,
    tautulliId: tNewTautulliId,
    plexName: tNewPlexName,
  );

  final List<ServerModel> tUpdatedServerList = [tUpdatedServerModel];

  test(
    'initialState should be SettingsInitial',
    () async {
      // assert
      expect(bloc.state, SettingsInitial());
    },
  );

  group('SettingsLoad', () {
    test(
      'should get SettingsModel from the Settings.getAllServers() use case',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // act
        bloc.add(SettingsLoad());
        await untilCalled(mockSettings.getAllServers());
        // assert
        verify(mockSettings.getAllServers());
      },
    );

    test(
      'should emit [SettingsLoadInProgress, SettingsLoadSuccess] when Settings are loaded successfully',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadInProgress(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SettingsLoad());
      },
    );
  });

  group('SettingsAddServer', () {
    test(
      'should call Settings.addServer() use case',
      () async {
        // act
        bloc.add(
          SettingsAddServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
        await untilCalled(
          mockSettings.addServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
        // assert
        verify(
          mockSettings.addServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after adding a server',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsAddServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
      },
    );
  });

  group('SettingsUpdateServer', () {
    test(
      'should call the Settings.updateServerById use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateServer(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
        await untilCalled(
          mockSettings.updateServerById(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
        // assert
        verify(
          mockSettings.updateServerById(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a server',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateServer(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
          ),
        );
      },
    );
  });

  group('SettingsDeleteServer', () {
    test(
      'should call the Settings.deleteServer use case',
      () async {
        // act
        bloc.add(SettingsDeleteServer(id: tId));
        await untilCalled(mockSettings.deleteServer(tId));
        // assert
        verify(mockSettings.deleteServer(tId));
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after deleting a server',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SettingsDeleteServer(id: tId));
      },
    );
  });

  group('SettingsUpdatePrimaryConnection', () {
    test(
      'should call the Settings.updatePrimaryConnection use case',
      () async {
        // act
        bloc.add(
          SettingsUpdatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        await untilCalled(
          mockSettings.updatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        // assert
        verify(
          mockSettings.updatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a primary connection',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );
  });

  group('SettingsUpdateSecondaryConnection', () {
    test(
      'should call the Settings.updateSecondaryConnection use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        await untilCalled(
          mockSettings.updateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        // assert
        verify(
          mockSettings.updateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a secondary connection',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );
  });

  group('SettingsUpdateDeviceToken', () {
    test(
      'should call the Settings.updateDeviceToken use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
        await untilCalled(
          mockSettings.updateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
        // assert
        verify(
          mockSettings.updateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a secondary connection',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // assert later
        final expected = [
          SettingsInitial(),
          SettingsLoadSuccess(serverList: tServerList),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
      },
    );
  });
}