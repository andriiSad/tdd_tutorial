import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
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
  });
  group('createUser', () async {
    const params = CreateUserParams.empty();

    test('should complete successfully when the status code is 200 or 201',
        () async {
      //arrange
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async =>
              Future.value(http.Response('User created successfully', 201)));
    });
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
    verify(() => client.post(
          Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: any(named: 'body'),
        )).called(1);

    verifyNoMoreInteractions(client);
  });
}
