abstract class AuthEven {}

class AuthStarted extends AuthEven {}


class AuthSignInRequested extends AuthEven {

  final String email;
  final String password;
  AuthSignInRequested(this.email, this.password);
}


class AuthSignUpRequested extends AuthEven {
  final String email;
  final String password;

  AuthSignUpRequested(this.email, this.password);
}


class AuthSignOutRequested extends AuthEven {}

