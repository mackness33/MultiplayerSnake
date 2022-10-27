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

class GameEventEnd extends GameEvent {
  const GameEventEnd();
}

class GameEventFail extends GameEvent {
  const GameEventFail();
}
