// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
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

class GameStateLoading extends GameState {
  const GameStateLoading();
}

class GameStateMounting extends GameState {
  const GameStateMounting();
}

class GameStatePlaying extends GameState {
  const GameStatePlaying();
}

class GameStateResuming extends GameState {
  const GameStateResuming();
}

class GameStateEnded extends GameState {
  final Exception? exception;
  const GameStateEnded(this.exception);
}
