import 'package:flutter/foundation.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class GameEventInitialize extends GameEvent {
  const GameEventInitialize();
}

class GameEventStart extends GameEvent {
  const GameEventStart();
}

class GameEventLoad extends GameEvent {
  const GameEventLoad();
}

class GameEventPlay extends GameEvent {
  const GameEventPlay();
}

class GameEventEnd extends GameEvent {
  const GameEventEnd();
}

class GameEventFail extends GameEvent {
  const GameEventFail();
}
