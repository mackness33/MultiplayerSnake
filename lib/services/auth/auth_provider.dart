import 'package:multiplayersnake/services/auth/auth_session.dart';
import 'package:multiplayersnake/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  AuthSession? get currentSession;

  Future<AuthSession?> get initialSession;

  Future<void> initialize();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logout();
}
