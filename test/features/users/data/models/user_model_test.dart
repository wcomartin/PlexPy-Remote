import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    duration: 8132145,
    friendlyName: 'Derek Rivard',
    isActive: 1,
    ipAddress: '192.168.0.224',
    lastPlayed: 'Hannah Gadsby: Douglas',
    lastSeen: 1597194400,
    mediaType: 'movie',
    plays: 3878,
    ratingKey: 99902,
    userId: 1526265,
    userThumb: 'https://plex.tv/users/5df7320378672025/avatar?c=1578073887',
  );

  test('should be a subclass of User entity', () async {
    //assert
    expect(tUserModel, isA<User>());
  });
  
  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tUserModel));
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result.userId, equals(jsonMap['user_id']));
      },
    );
  });
}