import 'dart:async';
import 'dart:core';

import 'package:multiplayersnake/services/socket/socket_provider.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:developer' as devtools;

class SocketService implements SocketProvider {
  final IO.Socket socket;
  String? room;
  String? player;
  bool? isAdmin;
  Completer<bool> _connectionCompleter;
  Completer<List<String>> _readyCompleter;
  Completer<Map<String, dynamic>> _playersCompleter;

  SocketService()
      : socket = IO.io(
          'http://10.0.2.2:3001',
          IO.OptionBuilder()
              .disableAutoConnect()
              .setTransports(['websocket']).build(),
        ),
        _connectionCompleter = Completer()..complete(false),
        _readyCompleter = Completer()..complete([]),
        _playersCompleter = Completer()..complete({});

  void init() {
    socket.onConnect((_) {
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

    socket.on('ready', (players) async {
      _readyCompleter.complete((players as List).cast<String>());
      if (_playersCompleter.isCompleted) {
        _playersCompleter = Completer();
      }
      _playersCompleter.complete({});
    });

    socket.on('player', (data) {
      if (!_playersCompleter.isCompleted) {
        _playersCompleter.complete(data);
      }
    });

    socket.on('abort', (data) {
      devtools.log('resetting');
      reset();
      throw AdminLeftGameException();
    });
  }

  void reset() {
    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.complete(false);
    }

    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete([]);
    }

    if (!_playersCompleter.isCompleted) {
      _playersCompleter.complete({});
    }

    room = null;
    player = null;
    isAdmin = null;
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
  void disconnect() => socket.disconnect();

  @override
  Future<List<String>> get start => _readyCompleter.future;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    Completer<bool> createdCompleter = Completer();
    devtools.log(data.toString());
    socket.emitWithAck('create', data,
        ack: (bool isCreated) => createdCompleter.complete(isCreated));

    if (!await createdCompleter.future) {
      throw RoomAlreadyExistedException();
    }

    if (_readyCompleter.isCompleted) {
      _readyCompleter = Completer();
    }

    room = data['room'];
    player = data['player'];
    isAdmin = true;

    return data;
  }

  @override
  Future<Map<String, dynamic>> join(Map<String, dynamic> data) async {
    Completer<Map<String, dynamic>?> joinedCompleter = Completer();

    socket.emitWithAck(
      'join',
      data,
      ack: (Map<String, dynamic> response) =>
          joinedCompleter.complete(response),
    );

    Map<String, dynamic>? response = await joinedCompleter.future;

    if (response?['isFull'] != null && response?['isFull'] is bool) {
      if (response!['isFull']) {
        throw RoomDoNotExistException();
      } else {
        throw RoomisFullException();
      }
    }

    if (response!['infos'] == null) {
      throw GeneralSocketException();
    }

    if (_readyCompleter.isCompleted) {
      _readyCompleter = Completer();
    }

    room = data['room'];
    player = data['player'];
    isAdmin = false;

    return response['infos'];
  }

  @override
  Stream<Map<String, dynamic>> streamPlayers() async* {
    while (_readyCompleter.isCompleted) {
      _playersCompleter = Completer();

      /**
       * {
       *    String player,
       *    bool isDeleted,
       * }
       */
      final Map<String, dynamic> response = await _playersCompleter.future;

      // it will be empty only if the ready compleater is compleated
      if (response.isNotEmpty) {
        yield response;
      }
    }

    // make sure the chatMessages is done.
    if (!_playersCompleter.isCompleted) {
      _playersCompleter.complete({});
    }
  }

  @override
  void ready() => socket.emit('ready', {'player': player, 'room': room});

  @override
  void deletePlayer() =>
      socket.emit('removePlayer', {'player': player, 'room': room});

  @override
  void leave() {
    if (isAdmin != null) {
      socket.emit(
          (isAdmin!) ? 'abort' : 'leave', {'player': player, 'room': room});
    }

    room = null;
    player = null;
    isAdmin = null;
  }
}

abstract class SocketException implements Exception {}

class GeneralSocketException implements SocketException {}

class ConnectionTimeoutException implements SocketException {}

class RoomAlreadyExistedException implements SocketException {}

class RoomisFullException implements SocketException {}

class RoomDoNotExistException implements SocketException {}

class AdminLeftGameException implements SocketException {}
