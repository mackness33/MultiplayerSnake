import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GameProvider game) : super(const GameStateReady()) {
    // start
    on<GameEventStart>((event, emit) async {
      emit(const GameStateLoading());
    });

    on<GameEventLoad>((event, emit) async {
      emit(const GameStateMounting());
      await game.mounted;
      // emit(const GameStatePlaying());
    });

    // play
    on<GameEventPlay>(((event, emit) async {
      await game.ending;
      emit(const GameStateResuming());
    }));

    // end
    on<GameEventEnd>(((event, emit) async {
      await game.ended;
      emit(const GameStateReady());
    }));

    // fail
    on<GameEventFail>(((event, emit) async {
      emit(const GameStateEnded(null));
    }));
  }
}
