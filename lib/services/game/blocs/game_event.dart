import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:multiplayersnake/models/game_settings.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class GameEventRemoved extends GameEvent {
  const GameEventRemoved();
}

class GameEventConnection extends GameEvent {
  const GameEventConnection();
}

class GameEventConfigured extends GameEvent {
  final Rect screen;
  const GameEventConfigured(this.screen);
}

class GameEventCreated extends GameEvent {
  final Rect screen;
  final GameSettings data;
  const GameEventCreated(this.screen, this.data);
}

class GameEventStarted extends GameEvent {
  final List<String> players;
  const GameEventStarted(this.players);
}

class GameEventPlayed extends GameEvent {
  const GameEventPlayed();
}

class GameEventEnded extends GameEvent {
  const GameEventEnded();
}

class GameEventFailed extends GameEvent {
  final Exception? exception;
  const GameEventFailed(this.exception);
}
