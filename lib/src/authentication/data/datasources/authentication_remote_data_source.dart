import 'package:http/http.dart' as http;
import '../models/user_model.dart';

abstract class IAuthenticationRemoteDataSource {
  //in remote dataSources we dont return Either type, throw error
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });
  //in remote dataSources we dont return entities, we return models, to be as loose as possible
  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/users';
const kGetUsersEndpoint = '/users';

class AuthenticationRemoteDataSourceImpl
    implements IAuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl(this._client);

  final http.Client _client;
  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //1.check to make sure that it returns the right data when
    // the response code is valid
    //2. check to make sure that it throws an custom exception with
    // the right message when the response code is not valid
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
