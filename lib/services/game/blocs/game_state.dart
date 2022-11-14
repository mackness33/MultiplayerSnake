// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:multiplayersnake/game/game.dart';
// import 'package:multiplayersnake/services/auth/auth_user.dart';

@immutable
abstract class GameState {
  const GameState();
}

class GameStateReady extends GameState {
  const GameStateReady();
}

class GameStateFailed extends GameState {
  final Exception? exception;
  const GameStateFailed(this.exception);
}

class GameStateStarted extends GameState {
  const GameStateStarted();
}

class GameStateConfigure extends GameState {
  const GameStateConfigure();
}

class GameStateCreate extends GameState {
  const GameStateCreate();
}

class GameStateLoad extends GameState {
  final MultiplayerSnakeGame game;
  const GameStateLoad(this.game);
}

class GameStateResume extends GameState {
  const GameStateResume();
}

class GameStateEnd extends GameState {
  const GameStateEnd();
}
