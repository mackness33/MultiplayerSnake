import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/database/database_exceptions.dart';
import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseFriendsService implements DatabaseFriendsProvider {
  final SupabaseClient _supabase;
  final String _id;

  List<DatabaseFriend> _friends = [];

  late final StreamController<List<DatabaseFriend>> _friendsStreamController;

  static final DatabaseFriendsService _shared =
      DatabaseFriendsService._sharedInstance();
  DatabaseFriendsService._sharedInstance()
      : _supabase = Supabase.instance.client,
        _id = AuthService.supabase().currentUser!.id {
    _friendsStreamController = StreamController<List<DatabaseFriend>>.broadcast(
      onListen: () {
        _friendsStreamController.sink.add(_friends);
      },
    );
  }
  factory DatabaseFriendsService() => _shared;

  Future<void> _cacheFriends() async {
    final Iterable<DatabaseFriend> allFriends = await getAllFriends();
    _friends = allFriends.toList();
    _friendsStreamController.add(_friends);
  }

  @override
  void init() async {
    await _cacheFriends();
  }

  Stream<List<DatabaseFriend>> get allFriends =>
      _friendsStreamController.stream;

  @override
  Future<Iterable<DatabaseFriend>> getAllFriends() async {
    try {
      final List<Map<String, dynamic>> friends =
          await _supabase.from(table).select();

      devtools.log('Friends: ${friends.toString()}');

      return friends.map((friendRow) => DatabaseFriend.fromRow(friendRow, _id));
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptFriend({required String id}) async {
    try {
      await _supabase.from(table).update({isConfirmedColumn: true}).match(
          {requesterColumn: id, followedColumn: _id});

      _cacheFriends();
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addFriend({required String id}) async {
    try {
      await _supabase
          .from(table)
          .insert({requesterColumn: _id, followedColumn: id});

      _cacheFriends();
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFriend({required String id}) async {
    try {
      await _supabase
          .from(table)
          .delete()
          .in_(requesterColumn, <String>[id, _id]).in_(
              followedColumn, <String>[id, _id]);

      _cacheFriends();
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }
}

const table = 'friends';
const queryAllFriendsWithEmail =
    'requester(id, email), followed(id, email), is_confirmed';
