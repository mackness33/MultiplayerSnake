import 'dart:async';

import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/views/statistics_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_exceptions.dart';
import 'dart:developer' as devtools show log;

class DatabaseGamesService implements DatabaseGamesProvider {
  final SupabaseClient supabase;
  final String user;

  List<DatabaseGame> _games = [];

  late final StreamController<List<DatabaseGame>> _gamesStreamController;

  static final DatabaseGamesService _shared =
      DatabaseGamesService._sharedInstance();
  DatabaseGamesService._sharedInstance()
      : supabase = Supabase.instance.client,
        user = AuthService.supabase().currentUser!.email {
    _gamesStreamController = StreamController<List<DatabaseGame>>.broadcast(
      onListen: () {
        _gamesStreamController.sink.add(_games);
      },
    );
  }
  factory DatabaseGamesService() => _shared;

  Future<void> _cacheGames() async {
    final allGames = await getAllGames();
    _games = allGames.toList();
    _gamesStreamController.add(_games);
  }

  @override
  void init() async {
    await _cacheGames();
  }

  Stream<List<DatabaseGame>> get allGames => _gamesStreamController.stream;

  @override
  Future<Iterable<DatabaseGame>> getAllGames() async {
    try {
      final List<
          Map<String,
              dynamic>> games = await supabase.from(table).select(
          '*, player0(email), player1(email), player2(email), player3(email)');

      return games.map((gameRow) => DatabaseGame.fromRow(gameRow, user));
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void applyFilters(Filters filters) {
    _gamesStreamController
        .add(_games.where((game) => filters.apply(game)).toList());
  }

  @override
  void onlyWinsFilter(bool? onlyWins) {
    _gamesStreamController.add(_games
        .where((game) => (onlyWins != null) ? onlyWins && game.winner : true)
        .toList());
  }

  @override
  void searchGame(String names) {
    _gamesStreamController.add(_games
        .where((game) => (names != '') ? names.contains(game.name) : true)
        .toList());
  }
}

const table = 'games';
