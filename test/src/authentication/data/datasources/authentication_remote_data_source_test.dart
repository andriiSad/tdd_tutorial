import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late IAuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client);
    registerFallbackValue(Uri.parse('$kBaseUrl$kCreateUserEndpoint'));
  });
  // setUpAll(() {
  //   registerFallbackValue(Uri.parse('$kBaseUrl$kCreateUserEndpoint'));
  // });
  group('createUser', () {
    const params = CreateUserParams.empty();

    test('should complete successfully when the status code is 200 or 201', () async {
      //arrange
      when(() => client.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('User created successfully', 201));
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
        () => client.post(Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
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
        when(() => client.post(any(), body: any(named: 'body')))
            .thenAnswer((_) async => http.Response('Invalid email address', 400));
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
          () => client.post(Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
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
}
