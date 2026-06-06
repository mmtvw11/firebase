abstract class AuthState {}


class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticeted extends AuthState{
  final UserModel user;
  AuthAuthenticeted(this.user);
}

class AuthUnauthenticeted extends AuthState {}


class AuthError extends AuthState {

  final String message;
  AuthError(this.message);
}


