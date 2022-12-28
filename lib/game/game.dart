import 'dart:async';
import 'dart:ui';
import 'dart:developer' as devtools;

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:multiplayersnake/game/components/board_component.dart';
import 'package:multiplayersnake/game/components/snake_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class MultiplayerSnakeGame extends FlameGame
    with HasTappableComponents, HasCollisionDetection, SingleGameInstance {
  final GameBloc gameBloc;
  final Rect screen;
  final GameRules gameRules;
  late final BoardComponent board;
  late final SnakeComponent player;
  late final double tileSize;

  MultiplayerSnakeGame(this.screen, this.gameRules, this.gameBloc) {
    tileSize = screen.width / 30;
    board = BoardComponent(screen, tileSize);
  }

  @override
  Future<void> onLoad() async {
    devtools.log('IsLoading');
    await super.onLoad();
    await add(
      FlameBlocProvider<GameBloc, GameState>.value(value: gameBloc),
    );
    await add(board);
    devtools.log('IsLoaded');
  }

  void end() => gameBloc.add(const GameEventPlayed());

  void eat(bool isSpecial) => gameBloc.add(GameEventEat(isSpecial));

  @override
  void onRemove() {
    devtools.log('IsRemoving');
    super.onRemove();
    if (!_endedCompleter.isCompleted) {
      _endedCompleter.complete();
    }
    devtools.log('IsRemoved');
  }

  @override
  void onDetach() {
    _endingCompleter.complete();
    devtools.log('isDetaching');
    super.onDetach();
    devtools.log('IsDetached');
  }

  @override
  void onAttach() {
    devtools.log('IsAttaching');
    super.onAttach();
    devtools.log('IsAttached');
  }

  @override
  void onMount() {
    devtools.log('IsMounting');
    super.onMount();
    devtools.log('IsMounted');
  }

  // endend
  final Completer<void> _endedCompleter = Completer();
  Future<void> get ended => _endedCompleter.future;

  // ending
  final Completer<void> _endingCompleter = Completer();
  Future<void> get ending => _endingCompleter.future;

  void addPlayers(List<String> players) => board.addPlayers(players);
}
