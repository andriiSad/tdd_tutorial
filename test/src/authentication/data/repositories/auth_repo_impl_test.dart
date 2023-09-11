import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockAuthRemoteDataSource extends Mock
    implements IAuthenticationRemoteDataSource {}

void main() {
  late IAuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthenticationRepositoryImpl(remoteDataSource);
  });

  group('createUser', () {
    const params = CreateUserParams.empty();
    const tException = APIException(
      message: 'Unknown error occurred',
      statusCode: 500,
    );
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
        final result = await repoImpl.createUser(
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
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            )).thenThrow(tException);

        //act
        final result = await repoImpl.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        );

        //assert
        expect(result, Left(APIFailure.fromException(tException)));

        //check that remote source's create user is get called, with correct data
        verify(() => remoteDataSource.createUser(
              createdAt: params.createdAt,
              name: params.name,
              avatar: params.avatar,
            )).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    const tException = APIException(
      message: 'Unknown error occurred',
      statusCode: 500,
    );
    test(
      'should call the [RemoteDataSource.getUsers] and return '
      '[List<UserModel>], when the call to remote source is successful',
      () async {
        //arrange
        when(() => remoteDataSource.getUsers()).thenAnswer((_) async => tUsers);
        //act
        final result = await repoImpl.getUsers();

        //assert
        expect(result, const Right<dynamic, List<User>>(tUsers));
        //check that remote source's create user is get called, with correct data
        verify(() => remoteDataSource.getUsers()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(() => remoteDataSource.getUsers()).thenThrow(tException);

        //act
        final result = await repoImpl.getUsers();

        //assert
        expect(result, Left(APIFailure.fromException(tException)));

        //check that remote source's create user is get called
        verify(() => remoteDataSource.getUsers()).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
