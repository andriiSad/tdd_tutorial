import '../../../../core/utils/typedef.dart';
import '../entities/user.dart';

abstract class IAuthenticationRepository {
  const IAuthenticationRepository();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
