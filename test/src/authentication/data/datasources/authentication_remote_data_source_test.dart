import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late IAuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client);
  });

  group('createUser', () {
    setUp(() {
      registerFallbackValue(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
      );
    });

    const params = CreateUserParams.empty();
    test('should complete successfully when the status code is 200 or 201',
        () async {
      //arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));
      //act
      final methodCall = remoteDataSource.createUser;
      //assert
      expect(
          methodCall(
            createdAt: params.createdAt,
            name: params.name,
            avatar: params.avatar,
          ),
          completes);
      verify(
        () => client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
            body: jsonEncode(
              {
                'createdAt': params.createdAt,
                'name': params.name,
                'avatar': params.avatar,
              },
            )),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
    test(
      'should throw [APIException] when the status code is not 200 or 201',
      () async {
        // arrange
        when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('Invalid email address', 400));
        // act
        final methodCall = remoteDataSource.createUser;
        // assert
        expect(
          methodCall(
            createdAt: params.createdAt,
            name: params.name,
            avatar: params.avatar,
          ),
          throwsA(const APIException(
            message: 'Invalid email address',
            statusCode: 400,
          )),
        );

        verify(
          () => client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode(
                {
                  'createdAt': params.createdAt,
                  'name': params.name,
                  'avatar': params.avatar,
                },
              )),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
  group('getUsers', () {
    setUp(() {
      registerFallbackValue(
        Uri.https(kBaseUrl, kGetUsersEndpoint),
      );
    });

    test(
      'should call the [RemoteDataSource.getUsers] and return [List<UserModel>]'
      ' when the status code is 200',
      () async {
        final tUsers = [const UserModel.empty()];

        // arrange
        when(() => client.get(any())).thenAnswer((_) async =>
            http.Response(jsonEncode([tUsers.first.toJson()]), 200));
        // act
        final result = await remoteDataSource.getUsers();
        // assert
        expect(result, tUsers);
        verify(
          () => client.get(
            Uri.https(kBaseUrl, kGetUsersEndpoint),
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
    test(
      'should throw [APIException] when the status code is not 200',
      () async {
        const tMessage = 'Server down, Server down, Server down';
        const tStatusCode = 500;

        // arrange
        when(() => client.get(any())).thenAnswer((_) async => http.Response(
              tMessage,
              tStatusCode,
            ));

        // act
        final methodCall = remoteDataSource.getUsers;

        // assert
        expect(
          methodCall(),
          throwsA(const APIException(
            message: tMessage,
            statusCode: tStatusCode,
          )),
        );

        verify(
          () => client.get(
            Uri.https(kBaseUrl, kGetUsersEndpoint),
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
