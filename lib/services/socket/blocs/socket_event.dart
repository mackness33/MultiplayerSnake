import 'package:flutter/foundation.dart';

@immutable
abstract class SocketEvent {
  const SocketEvent();
}

class SocketEventInitialized extends SocketEvent {
  const SocketEventInitialized();
}

class SocketEventConnection extends SocketEvent {
  const SocketEventConnection();
}

class SocketEventInitizialization extends SocketEvent {
  const SocketEventInitizialization();
}

class SocketEventDisconnection extends SocketEvent {
  const SocketEventDisconnection();
}
