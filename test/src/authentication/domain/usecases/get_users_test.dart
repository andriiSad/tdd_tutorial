import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  const testUsers = [User.empty()];
  test(
    'should call the [AuthRepo.getUsers] and return a list of users from the repository',
    () async {
      // arrange

      //STUB
      when(
        () => repository.getUsers(),
      ).thenAnswer((_) async => const Right(testUsers));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right<dynamic, List<User>>(testUsers));
      verify(
        () => repository.getUsers(),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
