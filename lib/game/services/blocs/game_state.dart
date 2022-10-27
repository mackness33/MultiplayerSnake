// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
// import 'package:multiplayersnake/services/auth/auth_user.dart';

@immutable
abstract class GameState {
  const GameState();
}

class GameStateUninitialized extends GameState {
  const GameStateUninitialized();
}

class GameStateFailed extends GameState {
  final Exception? exception;
  const GameStateFailed(this.exception);
}

class GameStateStarted extends GameState {
  const GameStateStarted();
}

class GameStateEnded extends GameState {
  final Exception? exception;
  const GameStateEnded(this.exception);
}
