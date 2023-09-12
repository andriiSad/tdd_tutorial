import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/get_users.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(
      CreateUserParams(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      ),
    );

    //use fold to handle errors
    result.fold(
        (failure) => emit(
              AuthError.fromFailure(failure),
            ),
        (_) => emit(
              const UserCreated(),
            ));
  }

  Future<void> getUsers() async {
    emit(const GettingUsers());

    final result = await _getUsers();

    //use fold to handle errors
    result.fold(
        (failure) => emit(
              AuthError.fromFailure(failure),
            ),
        (users) => emit(
              UsersLoaded(users),
            ));
  }
}
