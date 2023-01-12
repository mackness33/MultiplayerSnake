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
  Completer<bool> _endCompleter;
  Completer<Map<String, dynamic>> _allUserEndedCompleter;
  Completer<Map<String, dynamic>> _pointsCompleter;

  SocketService()
      : socket = IO.io(
          'http://10.0.2.2:3001',
          IO.OptionBuilder()
              .disableAutoConnect()
              .setTransports(['websocket']).build(),
        ),
        _connectionCompleter = Completer()..complete(false),
        _readyCompleter = Completer()..complete([]),
        _playersCompleter = Completer()..complete({}),
        _endCompleter = Completer()..complete(false),
        _pointsCompleter = Completer()..complete({}),
        _allUserEndedCompleter = Completer()..complete({});

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

    socket.on('ready', (playersInfo) async {
      List<String> players = (playersInfo as List).cast<String>();
      devtools.log(players.toString());
      if (players.isNotEmpty) {
        if (!_readyCompleter.isCompleted) {
          _readyCompleter.complete(players);
        }
        if (!_playersCompleter.isCompleted) {
          _playersCompleter.complete({});
        }
        if (_endCompleter.isCompleted) {
          _endCompleter = Completer();
        }

        devtools.log('IN READY: ${_allUserEndedCompleter.isCompleted}');

        if (_allUserEndedCompleter.isCompleted) {
          _allUserEndedCompleter = Completer();
        }
      }
    });

    socket.on('player', (data) {
      if (!_playersCompleter.isCompleted) {
        _playersCompleter.complete(data);
      }
    });

    socket.on('points', (data) {
      if (!_pointsCompleter.isCompleted) {
        _pointsCompleter.complete(data);
      }
    });

    socket.on('abort', (data) {
      devtools.log('resetting');
      reset();
      throw AdminLeftGameException();
    });

    socket.on('end', (data) {
      if (!_endCompleter.isCompleted) {
        _endCompleter.complete(false);
      }

      if (!_allUserEndedCompleter.isCompleted) {
        devtools.log(data.toString());
        _allUserEndedCompleter.complete((data as List)[0] ?? {});
      }

      reset();
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

    if (!_endCompleter.isCompleted) {
      _endCompleter.complete(false);
    }

    if (!_pointsCompleter.isCompleted) {
      _pointsCompleter.complete({});
    }

    if (!_allUserEndedCompleter.isCompleted) {
      _allUserEndedCompleter.complete({});
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

    if (!_connectionCompleter.isCompleted) {
      await _connectionCompleter.future;
    }

    devtools.log('let\'s connect');

    _connectionCompleter = Completer();
    socket.connect();

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
  Future<bool> get end => _endCompleter.future;

  @override
  void endGame() {
    socket.emit('end', {'player': player, 'room': room});
    if (!_endCompleter.isCompleted) {
      _endCompleter.complete(true);
    }
  }

  @override
  Future<Map<String, dynamic>> get endOfAllPartecipants =>
      _allUserEndedCompleter.future;

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
    while (!_readyCompleter.isCompleted) {
      _playersCompleter = Completer();

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
  Stream<Map<String, dynamic>> streamPoints() async* {
    while (!_endCompleter.isCompleted) {
      _pointsCompleter = Completer();

      final Map<String, dynamic> response = await _pointsCompleter.future;

      // it will be empty only if the ready compleater is compleated
      if (response.isNotEmpty) {
        yield response;
      }
    }

    // make sure the chatMessages is done.
    if (!_pointsCompleter.isCompleted) {
      _pointsCompleter.complete({});
    }
  }

  @override
  void ready() => socket.emit('ready', {'player': player, 'room': room});

  @override
  void eat(bool isSpecial) => socket
      .emit('eat', {'player': player, 'room': room, 'isSpecial': isSpecial});

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

class ExceededMaximumTimeException implements SocketException {}
