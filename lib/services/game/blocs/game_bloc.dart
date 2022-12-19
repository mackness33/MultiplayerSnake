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
        if (event.isCreating) {
          await manager.create(event.data.createSettingsToJson());
          rules = event.data;
          devtools.log("players: ${rules.players.toString()}");
          rules.addPlayer(rules.player.email, true);
        } else {
          Map<String, dynamic>? roomInfos =
              await manager.join(event.data.joinSettingsToJson());
          rules = GameRules.fromJson(
            roomInfos['rules'],
            roomInfos['players'],
            roomInfos['admin'],
            event.data.player,
          );
        }
        devtools.log("isCreating: ${event.isCreating}");
        devtools.log("players2: ${rules.players.toString()}");
        manager.newGame(event.screen, rules, this);
        Stream<Map<String, dynamic>> stream = manager.streamPlayers();
        emit(GameStateStartWaiting(rules, stream));
        await manager.start;
        emit(const GameStateStartLoading());
        emit(GameStateStartLoaded(manager.game!));
        emit(const GameStatePlayListening());
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

    on<GameEventDeletePlayer>(((event, emit) {
      manager.deletePlayer(event.email, event.room);
    }));

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
