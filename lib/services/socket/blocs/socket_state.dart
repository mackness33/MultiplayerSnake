// import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:multiplayersnake/game/game.dart';
// import 'package:multiplayersnake/services/auth/auth_user.dart';

@immutable
abstract class SocketState {
  const SocketState();
}

class SocketStateUninitialized extends SocketState {
  const SocketStateUninitialized();
}

class SocketStateError extends SocketState {
  final Exception? exception;
  const SocketStateError(this.exception);
}

class SocketStateReady extends SocketState {
  const SocketStateReady();
}

class SocketStateConnectionInProgress extends SocketState {
  const SocketStateConnectionInProgress();
}

class SocketStateInitialize extends SocketState {
  const SocketStateInitialize();
}

class SocketStateDisconnected extends SocketState {
  const SocketStateDisconnected();
}
