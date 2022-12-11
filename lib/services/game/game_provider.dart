import 'dart:ui';

import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';

abstract class GameProvider {
  Future<void> newGame(Rect screen, GameRules gameSettings, GameBloc gameBloc);
  MultiplayerSnakeGame? get game;
  Future<void> get ending;
  Future<void> get ended;
  Future<void> get loaded;
  Future<void> get mounted;
}
