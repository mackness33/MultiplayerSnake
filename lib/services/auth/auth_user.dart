import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart' as supabase show User;

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;

  const AuthUser(this.isEmailVerified, this.email, this.id);

  factory AuthUser.fromSupabase(supabase.User user) {
    final confirmationSentAt = user.confirmationSentAt?.split('.')[0];
    final createdAt = user.createdAt.split('.')[0];
    return AuthUser(confirmationSentAt == createdAt, user.email ?? '', user.id);
  }
}
