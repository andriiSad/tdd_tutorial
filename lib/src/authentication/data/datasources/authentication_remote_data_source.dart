import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
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

class AuthenticationRemoteDataSourceImpl implements IAuthenticationRemoteDataSource {
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
    final response = await _client.post(Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
        body: jsonEncode(
          {
            'createdAt': createdAt,
            'name': name,
            'avatar': avatar,
          },
        ));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw APIException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint'));
    if (response.statusCode != 200) {
      throw APIException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
    throw UnimplementedError();
  }
}
