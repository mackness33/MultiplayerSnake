import 'dart:ui';

import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class GameService implements GameProvider {
  MultiplayerSnakeGame? _game;
  GameRules? _rules;

  GameService()
      : _game = null,
        _rules = null;

  @override
  Future<void> newGame(
      Rect screen, GameRules gameSettings, GameBloc gameBloc) async {
    if (_game != null) {
      if (_game!.isLoaded) {
        _game!.onRemove();
      }
    }
    _game = MultiplayerSnakeGame(screen, gameSettings, gameBloc);
    _rules = gameSettings;
  }

  @override
  MultiplayerSnakeGame? get game => _game;

  @override
  GameRules? get rules => _rules;

  @override
  Future<void> get loaded async =>
      (_game != null) ? _game!.loaded : throw GameNotIstantietedException();
  @override
  Future<void> get mounted async =>
      (_game != null) ? _game!.mounted : throw GameNotIstantietedException();
  @override
  Future<void> get ended async =>
      (_game != null) ? _game!.ended : throw GameNotIstantietedException();
  @override
  Future<void> get ending async =>
      (_game != null) ? _game!.ending : throw GameNotIstantietedException();
}

class GameGeneralException implements Exception {}

class GameNotIstantietedException implements Exception {}
