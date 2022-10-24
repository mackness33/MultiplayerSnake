import 'package:multiplayersnake/services/auth/auth_provider.dart';
import 'package:multiplayersnake/services/auth/auth_session.dart';
import 'package:multiplayersnake/services/auth/supabase_auth_provider.dart';
import 'package:multiplayersnake/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.supabase() => AuthService(SupabaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  AuthSession? get currentSession => provider.currentSession;

  @override
  Future<AuthSession?> get initialSession => provider.initialSession;
}
