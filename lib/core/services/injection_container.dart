import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../src/authentication/data/datasources/authentication_remote_data_source.dart';
import '../../src/authentication/data/repositories/auth_repo_impl.dart';
import '../../src/authentication/domain/repositories/auth_repo.dart';
import '../../src/authentication/domain/usecases/create_user.dart';
import '../../src/authentication/domain/usecases/get_users.dart';
import '../../src/authentication/presentation/cubit/auth_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //use registerFactory for registering blocs
  //use registerLazySingleton for registering dependencies
  serviceLocator
    //App Logic
    ..registerFactory(() => AuthCubit(
          createUser: serviceLocator(),
          getUsers: serviceLocator(),
        ))

    //Use cases
    ..registerLazySingleton(() => CreateUser(serviceLocator()))
    ..registerLazySingleton(() => GetUsers(serviceLocator()))

    //Repositories
    ..registerLazySingleton<IAuthenticationRepository>(
        () => AuthenticationRepositoryImpl(serviceLocator()))

    //Data Sources
    ..registerLazySingleton<IAuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(serviceLocator()))

    //External Dependencies
    ..registerLazySingleton(http.Client.new);
}
