import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart' as supabase show Session;

import 'auth_user.dart';

@immutable
class AuthSession {
  final AuthUser? user;

  const AuthSession(this.user);

  factory AuthSession.fromSupabase(supabase.Session session) {
    return AuthSession(AuthUser.fromSupabase(session.user));
  }
}
