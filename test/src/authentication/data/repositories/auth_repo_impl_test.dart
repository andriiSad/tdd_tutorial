import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockAuthRemoteDataSource extends Mock
    implements IAuthenticationRemoteDataSource {}

void main() {
  late IAuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repository = AuthenticationRepositoryImpl(remoteDataSource);
  });

  const params = CreateUserParams.empty();

  group('createUser', () {
    test(
      'should call the [RemoteDataSource.createUser] and complete '
      'successfully, when the call to remote source is successful',
      () async {
        //arrange
        when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            )).thenAnswer((_) async {});
        //.thenAnswer((_) async => Future.value()); is also OK for void.

        //act
        final result = await repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        );

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's create user is get called, with correct data
        verify(() => remoteDataSource.createUser(
              createdAt: params.createdAt,
              name: params.name,
              avatar: params.avatar,
            )).called(1);
      },
    );
  });
}
