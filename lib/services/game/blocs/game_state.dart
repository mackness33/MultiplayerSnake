// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/models/game_rules.dart';
// import 'package:multiplayersnake/services/auth/auth_user.dart';

@immutable
abstract class GameState {
  const GameState();
}

class GameStateUnactive extends GameState {
  const GameStateUnactive();
}

@immutable
abstract class GameStateViewer {}

// READY
class GameStateReady extends GameState {
  const GameStateReady();
}

class GameStateReadyDisconnected extends GameStateReady {
  const GameStateReadyDisconnected();
}

class GameStateReadyConnecting extends GameStateUnactive {
  const GameStateReadyConnecting();
}

class GameStateReadyError extends GameStateUnactive {
  const GameStateReadyError();
}

class GameStateReadyConnected extends GameStateUnactive {
  const GameStateReadyConnected();
}

// CONFIGURE
class GameStateConfigure extends GameState {
  const GameStateConfigure();
}

class GameStateConfigureInitialized extends GameStateConfigure
    with GameStateViewer {
  const GameStateConfigureInitialized();
}

class GameStateConfigureCreated extends GameStateConfigure {
  const GameStateConfigureCreated();
}

// PLAY
class GameStatePlay extends GameState {
  const GameStatePlay();
}

class GameStateStartLoading extends GameStateUnactive {
  const GameStateStartLoading();
}

class GameStateStartLoaded extends GameStatePlay with GameStateViewer {
  final MultiplayerSnakeGame game;
  const GameStateStartLoaded(this.game);
}

class GameStateStartWaiting extends GameStatePlay with GameStateViewer {
  final GameRules rules;
  final Stream<Map<String, dynamic>> streamPlayers;
  const GameStateStartWaiting(this.rules, this.streamPlayers);
}

class GameStatePlayListening extends GameStatePlay {
  const GameStatePlayListening();
}

// END
class GameStateEnd extends GameState {
  const GameStateEnd();
}

class GameStateEndWaiting extends GameStateUnactive {
  const GameStateEndWaiting();
}

class GameStateEndResults extends GameStateEnd with GameStateViewer {
  const GameStateEndResults();
}

class GameStateEndRemoving extends GameStateUnactive {
  const GameStateEndRemoving();
}

// FAIL
class GameStateFailed extends GameState {
  final Exception? exception;
  const GameStateFailed(this.exception);
}

class GameStateConfigurationFailed extends GameState {
  final Exception? exception;
  const GameStateConfigurationFailed(this.exception);
}

// LEAVE
class GameStateLeaving extends GameStateUnactive {
  const GameStateLeaving();
}

class GameStateLeft extends GameState {
  const GameStateLeft();
}

class GameStateDisconnecting extends GameState {
  const GameStateDisconnecting();
}
