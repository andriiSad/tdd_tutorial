import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthenticationRepository repository;
  late CreateUser usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  const params = CreateUserParams.empty();

  test(
    'should call the [AuthRepo.createUser]',
    () async {
      // arrange

      //STUB
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(params);

      // assert
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
