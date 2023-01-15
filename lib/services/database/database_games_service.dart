import 'dart:async';
import 'dart:math';

import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_provider.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/views/information_views/statistics_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_exceptions.dart';
import 'dart:developer' as devtools show log;

class DatabaseGamesService implements DatabaseGamesProvider {
  final SupabaseClient _supabase;
  final DatabaseGamesStats _stats;
  String _email;
  String _id;
  Filters _lastFilters = Filters.empty();
  bool? _lastOnlyWins;
  String _lastNames = '';

  List<DatabaseGame> _games = [];

  late final StreamController<List<DatabaseGame>> _gamesStreamController;

  static final DatabaseGamesService _shared =
      DatabaseGamesService._sharedInstance();
  DatabaseGamesService._sharedInstance()
      : _supabase = Supabase.instance.client,
        _email = AuthService.supabase().currentUser!.email,
        _id = AuthService.supabase().currentUser!.id,
        _stats = DatabaseGamesStats.empty() {
    _gamesStreamController = StreamController<List<DatabaseGame>>.broadcast(
      onListen: () {
        _gamesStreamController.sink.add(_games);
      },
    );
  }
  factory DatabaseGamesService() => _shared;

  Future<void> _cacheGames() async {
    final allGames = await getAllGames();
    _stats.update(allGames.toList());
    _email = AuthService.supabase().currentUser!.email;
    _id = AuthService.supabase().currentUser!.id;
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
      final List<dynamic> games = await _supabase
          .from(table)
          .select(selectAllGamesOfUserQuery)
          .eq(firstPlayerColumn, _id);

      return games.map((gameRow) =>
          DatabaseGame.fromRow(gameRow as Map<String, dynamic>, _email));
    } on DatabaseException catch (_) {
      throw GenericDatabaseException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void applyFilters(Filters filters) {
    _lastFilters = filters;
    _applyAllFilters();
  }

  @override
  void onlyWinsFilter(bool? onlyWins) {
    _lastOnlyWins = onlyWins;
    _applyAllFilters();
  }

  @override
  void searchGame(String names) {
    _lastNames = names;
    _applyAllFilters();
  }

  void _applyAllFilters() {
    List<DatabaseGame> results = _games
        .where((game) =>
            (_lastNames != '') ? _lastNames.contains(game.name) : true)
        .toList();
    results = results
        .where((game) => (_lastOnlyWins != null)
            ? !_lastOnlyWins! ^ game.user.isWinner
            : true)
        .toList();
    results = results.where((game) => _lastFilters.apply(game)).toList();

    _stats.update(results);
    _gamesStreamController.add(results);
  }

  DatabaseGamesStats getStats() => _stats;
}

const table = 'games';
const selectAllGamesOfUserQuery =
    '*, player0(email), player1(email), player2(email), player3(email)';

class DatabaseGamesStats {
  int _countWins;
  int _countLosses;
  int _maxPointsMade;
  int _totalGamePlayed;

  DatabaseGamesStats(this._countWins, this._countLosses, this._maxPointsMade,
      this._totalGamePlayed);

  DatabaseGamesStats.empty()
      : _countWins = 0,
        _countLosses = 0,
        _maxPointsMade = 0,
        _totalGamePlayed = 0;

  int get countWins => _countWins;
  int get countLosses => _countLosses;
  int get maxPointsMade => _maxPointsMade;
  int get totalGamePlayed => _totalGamePlayed;

  void update(List<DatabaseGame> games) {
    _countWins = 0;
    _countLosses = 0;
    _maxPointsMade = 0;
    _totalGamePlayed = games.length;

    for (DatabaseGame game in games) {
      game.user.isWinner ? _countWins++ : _countLosses++;
      _maxPointsMade = max(_maxPointsMade, game.user.points);
    }
  }

  @override
  String toString() =>
      'Stats, countWins = $_countWins, countLosses = $_countLosses, maxPointsMade = $_maxPointsMade, totalGamePlayed = $_totalGamePlayed';
}
