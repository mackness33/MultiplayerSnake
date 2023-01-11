import 'dart:async';
import 'dart:math';

import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/views/statistics_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_exceptions.dart';
import 'dart:developer' as devtools show log;

class DatabaseProfilesService implements DatabaseProfilesProvider {
  final SupabaseClient _supabase;
  final String _user;

  DatabaseProfile _profile = const DatabaseProfile.empty();

  late final StreamController<DatabaseProfile> _profilesStreamController;

  static final DatabaseProfilesService _shared =
      DatabaseProfilesService._sharedInstance();
  DatabaseProfilesService._sharedInstance()
      : _supabase = Supabase.instance.client,
        _user = AuthService.supabase().currentUser!.email {
    _profilesStreamController = StreamController<DatabaseProfile>.broadcast(
      onListen: () {
        _profilesStreamController.sink.add(_profile);
      },
    );
  }
  factory DatabaseProfilesService() => _shared;

  Future<void> _cacheProfile({String? email}) async {
    _profile = await getProfile(email: email);
    _profilesStreamController.add(_profile);
  }

  @override
  void init() async {
    await _cacheProfile();
  }

  Stream<DatabaseProfile> get profile => _profilesStreamController.stream;

  @override
  Future<DatabaseProfile> getProfile({String? email}) async {
    try {
      final List<dynamic> profiles = await _supabase
          .from(table)
          .select()
          .eq(emailColumn, (email != null) ? email : _user);

      devtools.log(profiles.toString());

      if (profiles.isEmpty) {
        devtools.log('PROFILE NOT FOUND!!!  BIG PROBLEM');
      } else if (profiles.length >= 2) {
        devtools.log('TOO MANY PROFILE FOUND!!!  BIG PROBLEM');
      }

      return DatabaseProfile.fromRow(profiles.first);
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(
      {required String key, required dynamic value}) async {
    try {
      final List<Map<String, dynamic>> profiles = await _supabase
          .from(table)
          .update({key: value})
          .eq(emailColumn, _user)
          .select();

      if (profiles.isEmpty) {
        devtools.log('PROFILE NOT FOUND!!!  BIG PROBLEM');
      } else if (profiles.length >= 2) {
        devtools.log('TOO MANY PROFILE FOUND!!!  BIG PROBLEM');
      }

      _cacheProfile();
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }
}

const table = 'profiles';
const emailColumn = 'email';
