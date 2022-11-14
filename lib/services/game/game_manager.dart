import 'dart:ui';

import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class GameManager implements GameProvider {
  late MultiplayerSnakeGame? _game;

  GameManager() : _game = null;

  Future<void> newGame(Rect screen, GameBloc gameBloc) async {
    if (_game != null) {
      if (_game!.isLoaded) {
        _game!.onRemove();
      }
    }
    _game = MultiplayerSnakeGame(screen, gameBloc);
  }

  MultiplayerSnakeGame? get game => _game;

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
