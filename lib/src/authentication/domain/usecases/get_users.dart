import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/user.dart';
import '../repositories/auth_repo.dart';

class GetUsers extends UsecaseWithOutParams<List<User>> {
  const GetUsers(this._repository);

  final IAuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
