import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/game/game_provider.dart';
import 'package:multiplayersnake/services/socket/socket_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameOrchestrator manager)
      : super(const GameStateReadyDisconnected()) {
    // start
    on<GameEventConnection>((event, emit) async {
      emit(const GameStateReadyConnecting());
      try {
        await manager.connect();
        emit(const GameStateReadyConnected());
        emit(const GameStateConfigureInitialized());
      } catch (e) {
        emit(GameStateFailed(e as Exception));
      }
    });

    // configure
    on<GameEventConfigured>((event, emit) async {
      try {
        emit(const GameStateConfigureCreated());
      } catch (e) {
        devtools.log(e.toString());
        GameStateFailed(e as Exception);
      }
    });

    // configure
    on<GameEventCreated>((event, emit) async {
      try {
        emit(const GameStateStartLoading());
        await manager.newGame(event.screen, this);
        emit(GameStateStartLoaded(manager.game!));
        emit(const GameStateStartWaiting());
        emit(const GameStatePlayListening());
        await Future.delayed(const Duration(seconds: 30));
        manager.game!.end();
      } catch (e) {
        devtools.log(e.toString());
        emit(GameStateFailed(e as Exception));
      }
    });

    // play
    on<GameEventPlayed>(((event, emit) async {
      emit(const GameStateEndWaiting());
      await manager.ending;
      emit(const GameStateEndResults());
      manager.disconnect();
    }));

    // end
    on<GameEventEnded>(((event, emit) async {
      emit(const GameStateEndRemoving());
      await manager.ended;
      emit(const GameStateReadyDisconnected());
    }));

    // fail
    on<GameEventFailed>(((event, emit) async {
      emit(GameStateFailed(event.exception));
    }));
  }
}
