import 'dart:async';

import 'package:multiplayersnake/services/socket/socket_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:developer' as devtools;

class SocketService implements SocketProvider {
  final IO.Socket socket;
  Completer<bool> _connectionCompleter;
  Completer<bool> _createdCompleter;
  Completer<Map<String, dynamic>?> _joinedCompleter;

  SocketService()
      : socket = IO.io(
          'http://10.0.2.2:3001',
          IO.OptionBuilder()
              .disableAutoConnect()
              .setTransports(['websocket']).build(),
        ),
        _connectionCompleter = Completer()..complete(false),
        _createdCompleter = Completer()..complete(false),
        _joinedCompleter = Completer()..complete(null);

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

  @override
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

  @override
  void disconnect() {
    socket.disconnect();
  }

  @override
  Future<void> create(Map<String, dynamic> data) async {
    _createdCompleter = Completer();

    socket.emitWithAck('create', data,
        ack: (bool isCreated) => _createdCompleter.complete(isCreated));

    if (!await _createdCompleter.future) {
      throw RoomAlreadyExistedException();
    }
  }

  @override
  Future<Map<String, dynamic>> join(Map<String, dynamic> data) async {
    _joinedCompleter = Completer();

    socket.emitWithAck(
      'join',
      data,
      ack: (Map<String, dynamic> response) =>
          _joinedCompleter.complete(response),
    );

    Map<String, dynamic>? response = await _joinedCompleter.future;

    if (response?['isFull'] != null && response?['isFull'] is bool) {
      if (response!['isFull']) {
        throw RoomDoNotExistException();
      } else {
        throw RoomisFullException();
      }
    }

    devtools.log(response?['rules']);

    if (response?['rules'] == null) {
      throw GeneralSocketException();
    }

    return response!['rules'];
  }
}

abstract class SocketException implements Exception {}

class GeneralSocketException implements SocketException {}

class ConnectionTimeoutException implements SocketException {}

class RoomAlreadyExistedException implements SocketException {}

class RoomisFullException implements SocketException {}

class RoomDoNotExistException implements SocketException {}
