part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class CreatingUser extends AuthState {
  const CreatingUser();
}

final class GettingUsers extends AuthState {
  const GettingUsers();
}

class UserCreated extends AuthState {
  const UserCreated();
}

class UsersLoaded extends AuthState {
  const UsersLoaded(this.users);
  final List<User> users;

  @override
  List<String> get props => users.map((user) => user.id).toList();
}

class AuthError extends AuthState {
  const AuthError({
    required this.statusCode,
    required this.message,
  });

  factory AuthError.fromFailure(Failure failure) => AuthError(
        statusCode: failure.statusCode,
        message: 'Error: ${failure.message}',
      );

  final int statusCode;
  final String message;

  @override
  List<Object> get props => [statusCode, message];
}
