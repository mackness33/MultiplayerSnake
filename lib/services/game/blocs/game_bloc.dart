import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/socket/socket_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  StreamSubscription<Map<String, dynamic>>? _pointsSubscription;

  GameBloc(GameOrchestrator manager)
      : super(const GameStateReadyDisconnected()) {
    // start
    on<GameEventConnection>((event, emit) async {
      try {
        emit(const GameStateReadyConnecting());
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
        GameRules rules;
        if (event.isCreating) {
          await manager.create(event.data.createSettingsToJson());
          rules = event.data;
          rules.addPlayer(rules.player.email, true);
        } else {
          Map<String, dynamic>? roomInfos =
              await manager.join(event.data.joinSettingsToJson());
          rules = GameRules.fromJson(
            roomInfos['rules'],
            (roomInfos['players'] as List).cast<String>(),
            roomInfos['admin'],
            event.data.player,
            event.data.room,
          );
        }
        manager.newGame(event.screen, rules, this);
        Stream<Map<String, dynamic>> stream = manager.streamPlayers();
        emit(GameStateStartWaiting(rules, stream));
        add(GameEventStarted(await manager.start));
      } on Exception catch (e) {
        devtools.log(e.toString());
        if (e is SocketException) {
          emit(GameStateConfigurationFailed(e));
        } else if (e is AdminLeftGameException) {
          emit(const GameStateLeaving());
          manager.leave();
          emit(const GameStateLeft());
          manager.disconnect();
          emit(const GameStateReadyDisconnected());
        } else {
          emit(GameStateFailed(e));
        }
      }
    });

    // start
    on<GameEventStarted>((event, emit) async {
      try {
        // manager.addPlayers(event.players);
        manager
            .addPlayers(<String>['davidantonhy962@gmail.com', 'Bravo', 'Code']);
        emit(const GameStateStartLoading());
        Stream<Map<String, dynamic>> points = manager.streamPoints();
        await _pointsSubscription?.cancel();
        _pointsSubscription = points.listen((event) {
          devtools.log('score: $event');
          manager.updateScore(event['player'], event['isSpecial']);
        });

        emit(GameStateStartLoaded(manager.game!));
        emit(const GameStatePlayListening());
        bool correctlyEnded = await manager.end;
        if (!correctlyEnded) {
          add(GameEventPlayed(correctlyEnded));
        }
      } on Exception catch (e) {
        devtools.log(e.toString());
        emit(GameStateFailed(e));
        _pointsSubscription?.cancel();
      }
    });

    // delete player
    on<GameEventDeletePlayer>(((event, emit) {
      manager.deletePlayer();
    }));

    // ready
    on<GameEventReady>(((event, emit) {
      manager.ready();
    }));

    // eat
    on<GameEventEat>(((event, emit) {
      manager.eat(event.isSpecial);
    }));

    // leave
    on<GameEventLeft>(((event, emit) async {
      await _pointsSubscription?.cancel();
      emit(const GameStateLeaving());
      manager.leave();
      emit(const GameStateLeft());
      manager.disconnect();
      emit(const GameStateReadyDisconnected());
    }));

    // end
    on<GameEventPlayed>(((event, emit) async {
      if (event.hasCorrectlyEnded) {
        manager.endGame();
        _pointsSubscription?.cancel();
        await manager.endOfAllPartecipants;
      }
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
      await _pointsSubscription?.cancel();
      emit(GameStateFailed(event.exception));
    }));
  }
}
