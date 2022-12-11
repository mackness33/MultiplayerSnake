import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'dart:developer' as devtools;

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
    // on<GameEventConfigured>((event, emit) async {
    //   try {
    //     emit(const GameStateConfigureCreated());
    //   } catch (e) {
    //     devtools.log(e.toString());
    //     GameStateFailed(e as Exception);
    //   }
    // });

    // configure
    on<GameEventConfigured>((event, emit) async {
      try {
        GameRules rules;
        if (event.create) {
          await manager.create(event.data.createSettingsToJson());
          rules = event.data;
        } else {
          rules = GameRules.fromJson(
              await manager.join(event.data.joinSettingsToJson()));
        }
        manager.newGame(event.screen, rules, this);
        emit(const GameStateStartWaiting());
      } on Exception catch (e) {
        devtools.log(e.toString());
        if (e is SocketException) {
          emit(GameStateConfigurationFailed(e));
        } else {
          emit(GameStateFailed(e));
        }
      }
    });

    // start
    on<GameEventStarted>((event, emit) async {
      try {
        emit(const GameStateStartLoading());
        emit(GameStateStartLoaded(manager.game!));
        emit(const GameStatePlayListening());
      } catch (e) {
        devtools.log(e.toString());
        emit(GameStateFailed(e as Exception));
      }
    });

    // end
    on<GameEventPlayed>(((event, emit) async {
      emit(const GameStateEndWaiting());
      await manager.ending;
      emit(const GameStateEndResults());
      manager.disconnect();
    }));

    // remove
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
