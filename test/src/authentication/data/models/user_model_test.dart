import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  final tJson = fixture('user.json');

  final tMap = jsonDecode(tJson) as DataMap;

  test(
    'should be subclass of User',
    () {
      // assert
      expect(tModel, isA<User>());
    },
  );
  group('fromMap', () {
    test(
      'should return a [UserModel] with the right data',
      () {
        // act
        final result = UserModel.fromMap(tMap);

        // assert
        expect(result, tModel);
      },
    );
  });
  group('fromJson', () {
    test(
      'should return a [UserModel] with the right data',
      () {
        // act
        final result = UserModel.fromJson(tJson);

        // assert
        expect(result, tModel);
      },
    );
  });
  group('toMap', () {
    test(
      'should return a valid DataMap',
      () {
        // act
        final result = tModel.toMap();

        // assert
        expect(result, isA<DataMap>());
        expect(result, tMap);
        // expect(result['id'], tModel.id);
        // expect(result['createdAt'], tModel.createdAt);
        // expect(result['name'], tModel.name);
        // expect(result['avatar'], tModel.avatar);
      },
    );
  });
  group('toJson', () {
    test(
      'should return a valid [JSON] string',
      () {
        //arrange
        final tJsonString = jsonEncode(tMap);

        // act
        final result = tModel.toJson();

        // assert
        expect(result, isA<String>());
        expect(result, tJsonString);
      },
    );
  });
  group('copyWith', () {
    test('should create a new UserModel with updated fields', () {
      //act
      final updatedModel = tModel.copyWith(name: '_updated.name');

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.name, '_updated.name');
      expect(updatedModel.id, tModel.id);
      expect(updatedModel.createdAt, tModel.createdAt);
      expect(updatedModel.avatar, tModel.avatar);
    });
  });
}
