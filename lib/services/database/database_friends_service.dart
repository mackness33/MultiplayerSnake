import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/database/database_exceptions.dart';
import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseFriendsService implements DatabaseFriendsProvider {
  final SupabaseClient _supabase;
  String _id;
  String _email;

  List<DatabaseFriend> _friends = [];
  List<DatabaseFriend> _players = [];

  late final StreamController<List<DatabaseFriend>> _friendsStreamController;
  late final StreamController<List<DatabaseFriend>> _playersStreamController;

  static final DatabaseFriendsService _shared =
      DatabaseFriendsService._sharedInstance();
  DatabaseFriendsService._sharedInstance()
      : _supabase = Supabase.instance.client,
        _id = AuthService.supabase().currentUser!.id,
        _email = AuthService.supabase().currentUser!.email {
    _playersStreamController =
        StreamController<List<DatabaseFriend>>.broadcast();
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
    _id = AuthService.supabase().currentUser!.id;
    _email = AuthService.supabase().currentUser!.email;
    await _cacheFriends();
  }

  Stream<List<DatabaseFriend>> get allFriends =>
      _friendsStreamController.stream;

  Stream<List<DatabaseFriend>> get searchedPlayers =>
      _playersStreamController.stream;

  @override
  Future<Iterable<DatabaseFriend>> getAllFriends() async {
    try {
      final List<Map<String, dynamic>> friends =
          await _supabase.from(friendsTable).select(queryAllFriendsWithEmail);

      devtools.log('Friends: ${friends.toString()}');
      devtools.log('id: $_id');
      devtools.log('email: $_email');

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
      await _supabase
          .from(friendsTable)
          .update({isConfirmedColumn: true}).match(
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
          .from(friendsTable)
          .insert({requesterColumn: _id, followedColumn: id});

      _cacheFriends();
      _players.removeWhere((friendship) => friendship.followed == id);
      _playersStreamController.add(_players);
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
          .from(friendsTable)
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

  @override
  Future<void> searchPlayer(String player) async {
    try {
      final List<dynamic> players = await _supabase
          .from(profilesTable)
          .select('id, email')
          .like(emailColumn, '*$player*')
          .neq(emailColumn, _email);

      devtools.log('Players: ${players.toString()}');

      Iterable<DatabaseFriend> playersNotFriends = players
          .map((playerRow) => DatabaseFriend.notYetFriends(playerRow, _id))
          .where(
            (possibleFriendship) => _friends.every(
              (friendship) =>
                  friendship.requester != possibleFriendship.followed &&
                  friendship.followed != possibleFriendship.followed,
            ),
          );

      _players = playersNotFriends.toList();
      _playersStreamController.add(_players);
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }
}

const friendsTable = 'friends';
const profilesTable = 'profiles';
const queryAllFriendsWithEmail =
    'requester(id, email), followed(id, email), is_confirmed';
