import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multiplayersnake/services/auth/auth_exceptions.dart';
import 'package:multiplayersnake/services/auth/auth_provider.dart';
import 'package:multiplayersnake/services/auth/auth_session.dart';
import 'package:multiplayersnake/services/auth/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, Supabase, SupabaseAuth;

final supabase = Supabase.instance.client;

class SupabaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);

      final confirmationSentAt =
          response.user?.confirmationSentAt?.split('.')[0];
      final createdAt = response.user?.createdAt.split('.')[0];

      if (confirmationSentAt == createdAt) {
        final user = response.user;
        if (user != null) {
          return AuthUser.fromSupabase(user);
        }

        throw GenericAuthException();
      } else {
        throw EmailAlreadyInUseException();
      }
    } on AuthException catch (e) {
      if (e.message.contains('Password')) {
        throw WeakPasswordException();
      } else if (e.message.contains('email')) {
        throw InvalidEmailFormatException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = Supabase.instance.client.auth.currentUser;
    return (user != null) ? AuthUser.fromSupabase(user) : null;
  }

  @override
  Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANNON_KEY'),
    );
  }

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      }

      throw GenericAuthException();
    } on AuthException catch (e) {
      if (e.statusCode == '422') {
        throw InvalidCredentialsException();
      }

      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (supabase.auth.currentUser != null) {
        await supabase.auth.signOut();
      } else {
        throw UserNotLoggedInException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthSession? get currentSession {
    final session = Supabase.instance.client.auth.currentSession;
    return (session != null) ? AuthSession.fromSupabase(session) : null;
  }

  @override
  Future<AuthSession?> get initialSession async {
    try {
      final session = await SupabaseAuth.instance.initialSession;
      return (session != null) ? AuthSession.fromSupabase(session) : null;
    } on AuthException catch (_) {
      throw GenericAuthException();
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
