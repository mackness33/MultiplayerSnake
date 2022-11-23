import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/game/game_provider.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameProvider manager) : super(const GameStateReady()) {
    // start
    on<GameEventStarted>((event, emit) async {
      emit(const GameStateConfigure());
    });

    // configure
    on<GameEventConfigured>((event, emit) async {
      try {
        await manager.newGame(event.screen, this);
        emit(GameStateLoad(manager.game!));
        await Future.delayed(const Duration(seconds: 30));
        manager.game!.end();
      } catch (e) {
        devtools.log(e.toString());
        GameStateFailed(e as Exception);
      }
    });

    // play
    on<GameEventRemoved>(((event, emit) async {
      emit(const GameStateResume());
    }));

    // play
    on<GameEventPlayed>(((event, emit) async {
      emit(const GameStateResume());
      await manager.ending;
    }));

    // end
    on<GameEventEnded>(((event, emit) async {
      emit(const GameStateEnd());
      await manager.ended;
      emit(const GameStateReady());
    }));

    // fail
    on<GameEventFailed>(((event, emit) async {
      emit(GameStateFailed(event.exception));
    }));
  }
}
