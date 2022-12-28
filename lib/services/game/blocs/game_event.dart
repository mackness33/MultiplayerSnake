import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:multiplayersnake/models/game_rules.dart';

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
  final GameRules data;
  final bool isCreating;
  const GameEventConfigured(this.screen, this.data, this.isCreating);
}

class GameEventStarted extends GameEvent {
  final List<String> players;
  const GameEventStarted(this.players);
}

class GameEventDeletePlayer extends GameEvent {
  final String email;
  final String room;
  const GameEventDeletePlayer(this.email, this.room);
}

class GameEventReady extends GameEvent {
  const GameEventReady();
}

class GameEventPlayed extends GameEvent {
  const GameEventPlayed();
}

class GameEventEnded extends GameEvent {
  const GameEventEnded();
}

class GameEventLeft extends GameEvent {
  const GameEventLeft();
}

class GameEventFailed extends GameEvent {
  final Exception? exception;
  const GameEventFailed(this.exception);
}
