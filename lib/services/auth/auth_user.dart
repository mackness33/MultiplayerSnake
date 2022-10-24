import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart' as supabase show User;

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromSupabase(supabase.User user) {
    final confirmationSentAt = user.confirmationSentAt?.split('.')[0];
    final createdAt = user.createdAt.split('.')[0];
    return AuthUser(confirmationSentAt == createdAt);
  }
}
