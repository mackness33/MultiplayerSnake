import 'package:flutter/foundation.dart';

@immutable
class DatabaseProfile {
  final String? id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? website;

  const DatabaseProfile(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.avatarUrl,
      required this.website});

  const DatabaseProfile.empty()
      : id = null,
        email = null,
        fullName = null,
        avatarUrl = null,
        website = null;

  DatabaseProfile.fromRow(Map<String, dynamic> row)
      : id = row[idColumn] as String,
        email = row[emailColumn] as String,
        fullName = row[fullNameColumn] ?? '',
        avatarUrl = row[avatarUrlColumn] ?? '',
        website = row[websiteColumn] ?? '';

  @override
  String toString() => 'Profile, ID = $id, email: $email';

  @override
  bool operator ==(covariant DatabaseProfile other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const profilesTable = 'profiles';
const idColumn = 'id';
const emailColumn = 'email';
const fullNameColumn = 'full_name';
const avatarUrlColumn = 'avatar_url';
const websiteColumn = 'website';
