import 'dart:ui';

import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/services/socket/socket_service.dart';
import 'package:multiplayersnake/services/socket/socket_provider.dart';

class GameOrchestrator implements GameProvider, SocketProvider {
  GameService gameService;
  SocketService socketService;

  GameOrchestrator()
      : gameService = GameService(),
        socketService = SocketService()..init();

  Future<void> newGame(Rect screen, GameBloc gameBloc) async =>
      gameService.newGame(screen, gameBloc);

  MultiplayerSnakeGame? get game => gameService.game;

  @override
  Future<void> get loaded async => gameService.loaded;
  @override
  Future<void> get mounted async => gameService.mounted;
  @override
  Future<void> get ended async => gameService.ended;
  @override
  Future<void> get ending async => gameService.ending;

  @override
  Future<void> connect() => socketService.connect();

  @override
  void disconnect() => socketService.disconnect();
}
