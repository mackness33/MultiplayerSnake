import 'dart:async';

import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_exceptions.dart';
import 'dart:developer' as devtools show log;

class GamesService implements DatabaseProvider {
  final SupabaseClient supabase;
  final String user;

  List<DatabaseGame> _games = [];

  final _gamesStreamController =
      StreamController<List<DatabaseGame>>.broadcast();

  Future<void> _cacheGames() async {
    final allGames = await getAllGames();
    _games = allGames.toList();
    _gamesStreamController.add(_games);
  }

  GamesService({required this.user}) : supabase = Supabase.instance.client;

  void init() async {
    await _cacheGames();
  }

  @override
  Future<Iterable<DatabaseGame>> getAllGames() async {
    try {
      final List<Map<String, dynamic>> games =
          await supabase.from('games').select('*');
      devtools.log(games.toString());

      return games.map((gameRow) => DatabaseGame.fromRow(gameRow));
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Iterable<DatabaseGame>> getGames(List<String> names) async {
    try {
      final List<Map<String, dynamic>> games =
          await supabase.from('games').select('*').in_('name', names);

      return games.map((gameRow) => DatabaseGame.fromRow(gameRow));
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DatabaseGame> getGame(int id) async {
    try {
      final List<Map<String, dynamic>> result =
          await supabase.from('games').select('*').eq('id', id);
      devtools.log(result.toString());

      if (result.isEmpty) {
        throw CouldNotFindGamesException();
      }

      return DatabaseGame.fromRow(result.first);
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }
}
