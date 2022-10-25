import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventShouldSignup extends AuthEvent {
  const AuthEventShouldSignup();
}

class AuthEventSignup extends AuthEvent {
  final String email;
  final String password;
  const AuthEventSignup(this.email, this.password);
}
