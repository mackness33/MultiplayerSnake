import 'dart:async';
import 'dart:ui';
import 'dart:developer' as devtools;

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:multiplayersnake/game/components/board_component.dart';
import 'package:multiplayersnake/game/components/snake_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class MultiplayerSnakeGame extends FlameGame
    with HasTappableComponents, SingleGameInstance, GameProvider {
  final Rect screen;
  late final BoardController board;
  late final double tileSize;
  final GameBloc gameBloc;

  MultiplayerSnakeGame(this.screen, this.gameBloc) {
    tileSize = screen.width / 30;
    board = BoardController(
      screen.width ~/ tileSize,
      screen.height ~/ tileSize,
    );
  }

  // MultiplayerSnakeGame.empty()
  //     : screen = Rect.zero,
  //       board = BoardController(1, 1),
  //       tileSize = 0;

  @override
  Future<void> onLoad() async {
    print('IsLoading');
    await super.onLoad();
    await add(
      FlameBlocProvider<GameBloc, GameState>.value(value: gameBloc),
    );
    await add(BoardComponent(screen, board, tileSize));
    await add(SnakeComponent(screen, board, tileSize));
    print('IsLoaded');
  }

  void end() => gameBloc.add(const GameEventPlayed());

  @override
  void onRemove() {
    // gameBloc.add(const GameEventEnded());
    // gameBloc.add(const GameEventRemoved());
    print('IsRemoving');
    super.onRemove();
    if (!_endedCompleter.isCompleted) {
      _endedCompleter.complete();
    }
    print('IsRemoved');
  }

  @override
  void onDetach() {
    // gameBloc.add(const GameEventPlayed());
    _endingCompleter.complete();
    print('isDetaching');
    super.onDetach();
    print('IsDetached');
  }

  @override
  void onAttach() {
    print('IsAttaching');
    super.onAttach();
    print('IsAttached');
  }

  @override
  void onMount() {
    print('IsMounting');
    super.onMount();
    print('IsMounted');
  }

  // endend
  final Completer<void> _endedCompleter = Completer();
  @override
  Future<void> get ended => _endedCompleter.future;

  // ending
  final Completer<void> _endingCompleter = Completer();
  @override
  Future<void> get ending => _endingCompleter.future;
}
