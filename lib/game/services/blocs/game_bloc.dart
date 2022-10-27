import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/game/services/blocs/game_event.dart';
import 'package:multiplayersnake/game/services/blocs/game_state.dart';
import 'package:multiplayersnake/game/services/game_provider.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    bool? isLoaded,
  }) : super(const GameStateUninitialized()) {
    // start
    on<GameEventStart>((event, emit) async {
      try {
        emit(const GameStateStarted());
      } on Exception catch (e) {
        emit(GameStateEnded(e));
      }
    });

    // initialize
    on<GameEventInitialize>(((_, emit) async {
      emit(const GameStateStarted());
    }));

    // end
    on<GameEventEnd>(((event, emit) async {
      emit(const GameStateEnded(null));
    }));

    // fail
    on<GameEventFail>(((event, emit) async {
      emit(const GameStateEnded(null));
    }));
  }
}
