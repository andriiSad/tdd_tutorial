import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tFailure = APIFailure(message: 'APIFailure message', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUsers();
    cubit = AuthCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  //ALWAYS CLOSE BLOC/CUBIT AFTER EACH TEST
  tearDown(() => cubit.close());

  test(
    'initial state should be [AuthInitial()]',
    () async {
      expect(cubit.state, const AuthInitial());
    },
  );
  group('createUser', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      //USE THIS FOR BLOC TESTS(thats the only difference in tests)
      // act: (bloc) => bloc.add(
      //   CreateUserEvent(
      //     createdAt: tCreateUserParams.createdAt,
      //     name: tCreateUserParams.name,
      //     avatar: tCreateUserParams.avatar,
      //   ),
      // ),
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        const UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'should emit [CreatingUser, AuthError] when NOT successful ',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return cubit;
      },
      //USE THIS FOR BLOC TESTS(thats the only difference in tests)
      // act: (bloc) => bloc.add(
      //   CreateUserEvent(
      //     createdAt: tCreateUserParams.createdAt,
      //     name: tCreateUserParams.name,
      //     avatar: tCreateUserParams.avatar,
      //   ),
      // ),
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        AuthError.fromFailure(tFailure),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
  group('getUsers', () {
    const tUsers = [User.empty()];

    blocTest<AuthCubit, AuthState>(
      'should emit [GettingUsers, UsersLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Right(tUsers),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsers(),
        const UsersLoaded(tUsers),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'should emit [GettingUsers, AuthError] when NOT successful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsers(),
        AuthError.fromFailure(tFailure),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
