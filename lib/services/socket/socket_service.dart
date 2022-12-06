import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:developer' as devtools;

class SocketService {
  final IO.Socket socket;
  Completer<bool> _connectionCompleter;

  SocketService()
      : socket = IO.io(
          'http://10.0.2.2:3001',
          IO.OptionBuilder()
              .disableAutoConnect()
              .setTransports(['websocket']).build(),
        ),
        _connectionCompleter = Completer()..complete(false);

  void init() {
    socket.onConnect((_) async {
      devtools.log('Connected to: ${socket.id}');
      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.complete(true);
      }
    });
    socket.onConnectError((data) {
      devtools.log('Connection error on ${socket.id}: $data');
      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.complete(false);
      }
    });
    socket.onDisconnect((_) {
      devtools.log('Disconnected from: ${socket.id}');
    });
    socket.onError((data) {
      devtools.log('Error on ${socket.id}: $data');
    });
  }

  Future<void> connect() async {
    if (socket.connected) {
      socket.disconnect();
    }

    devtools
        .log('are we already connected? ${_connectionCompleter.isCompleted}');
    if (!_connectionCompleter.isCompleted) {
      await _connectionCompleter.future;
    }

    devtools.log('let\'s connect');

    _connectionCompleter = Completer();
    socket.connect();

    devtools.log(
        'emitted, waiting for the response: ${_connectionCompleter.isCompleted}');
    if (!_connectionCompleter.isCompleted) {
      await _connectionCompleter.future;
    }

    devtools.log('connected? ${!socket.disconnected}');
    if (socket.disconnected) {
      throw ConnectionTimeoutException();
    }
  }

  void disconnect() {
    socket.disconnect();
  }
}

class ConnectionTimeoutException implements Exception {}
