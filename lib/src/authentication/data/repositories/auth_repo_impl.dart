import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
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
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
    return const Right(null);
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
