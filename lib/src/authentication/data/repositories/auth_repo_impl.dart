import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  const AuthenticationRepositoryImpl(this._remoteDataSource);
  final IAuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //call the remote datasource(and for all injected dependencies)
    //check if method returns the proper data
    // //(if there is no exeption)
    // //checkif when remote datasource throws an exception we return Failure
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<User>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
