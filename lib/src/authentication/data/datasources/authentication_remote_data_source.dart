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
