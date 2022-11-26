import 'dart:ui';

import 'package:flutter/foundation.dart';

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
  const GameEventCreated(this.screen);
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
