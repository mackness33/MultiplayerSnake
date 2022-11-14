import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class GameEventRemoved extends GameEvent {
  const GameEventRemoved();
}

class GameEventStarted extends GameEvent {
  const GameEventStarted();
}

class GameEventConfigured extends GameEvent {
  final Rect screen;
  const GameEventConfigured(this.screen);
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
