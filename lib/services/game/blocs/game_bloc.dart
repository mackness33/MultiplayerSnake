import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_manager.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';
import 'dart:developer' as devtools;

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameManager manager) : super(const GameStateReady()) {
    // start
    on<GameEventStarted>((event, emit) async {
      emit(const GameStateConfigure());
    });

    // configure
    on<GameEventConfigured>((event, emit) async {
      try {
        devtools.log('Pre create');
        await manager.newGame(event.screen, this);
        devtools.log('after new Game');

        emit(GameStateLoad(manager.game!));
        devtools.log('after Loadedstate');
        await Future.delayed(const Duration(seconds: 5));
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
