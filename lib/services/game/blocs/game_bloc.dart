import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/game/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/socket/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
        // Stream<Map<String, dynamic>> stream = manager.streamPlayers();
        // manager.waitingPlayersStream;
        // emit(GameStateStartWaiting(rules, stream));
        emit(GameStateStartWaiting(rules, manager.waitingPlayersStream));
        add(GameEventStarted(await manager.start));
      } on SocketException catch (e) {
        devtools.log(e.toString());
        if (e is AdminLeftGameException) {
          devtools.log('about to leeave the game. Admin has left');
          add(const GameEventLeft());
        } else {
          devtools.log('Dunno, something happend');
          emit(GameStateConfigurationFailed(e));
        }
      } on Exception catch (e) {
        devtools.log(e.toString());
        emit(GameStateFailed(e));
      }
    });

    // start
    on<GameEventStarted>((event, emit) async {
      try {
        if (event.players.isEmpty) {
          add(const GameEventLeft());
          return;
        }
        manager.addPlayers(event.players);
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
      } on SocketException catch (e) {
        devtools.log(e.toString());
        if (e is AdminLeftGameException) {
          devtools.log('about to leeave the game. Admin has left');
          add(const GameEventLeft());
        } else {
          devtools.log('Dunno, something happend');
          emit(GameStateConfigurationFailed(e));
        }
      } on Exception catch (e) {
        devtools.log(e.toString());
        emit(GameStateFailed(e));
        _pointsSubscription?.cancel();
      }
    });

    // delete player
    on<GameEventRemovePlayer>(((event, emit) {
      manager.removePlayer(event.deletedUserEmail);
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
      emit(const GameStateEndWaiting());
      if (event.hasCorrectlyEnded) {
        manager.endGame();
      }
      _pointsSubscription?.cancel();
      final resume = await manager.results;
      await manager.ending;
      devtools.log(resume.toString());
      emit(GameStateEndResults(
          DatabaseGame.fromJSON(resume, manager.rules!.player.email)));
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
