// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:multiplayersnake/game/game.dart';
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

class GameStateReady extends GameState {
  const GameStateReady();
}

class GameStateReadyDisconnected extends GameStateReady {
  const GameStateReadyDisconnected();
}

class GameStateReadyConnecting extends GameStateUnactive {
  const GameStateReadyConnecting();
}

class GameStateReadyConnected extends GameStateUnactive {
  const GameStateReadyConnected();
}

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

class GameStateStartWaiting extends GameStatePlay {
  const GameStateStartWaiting();
}

class GameStatePlayListening extends GameStatePlay {
  const GameStatePlayListening();
}

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

class GameStateFailed extends GameState {
  final Exception? exception;
  const GameStateFailed(this.exception);
}
