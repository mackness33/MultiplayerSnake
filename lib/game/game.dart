import 'dart:async';
import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:multiplayersnake/game/components/background_component.dart';
import 'package:multiplayersnake/game/components/body_component.dart';
import 'package:multiplayersnake/game/components/snake_component.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/game/views/play_view.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class MultiplayerSnakeGame extends FlameGame
    with HasTappableComponents, SingleGameInstance, GameProvider {
  // late final RouterComponent router;
  final Rect screen;
  late final BoardController board;
  late final double tileSize;

  MultiplayerSnakeGame(this.screen) {
    tileSize = screen.width / 30;
    board = BoardController(
      screen.width ~/ tileSize,
      screen.height ~/ tileSize,
    );
  }

  MultiplayerSnakeGame.empty()
      : screen = Rect.zero,
        board = BoardController(1, 1),
        tileSize = 0;

  @override
  Future<void> onLoad() async {
    print('IsLoading');
    await add(Background(screen, board, tileSize));
    await add(SnakeComponent(screen, board, tileSize));
    print('IsLoaded');
  }

  @override
  void onRemove() {
    print('IsRemoving');
    super.onRemove();
    if (!_endedCompleter.isCompleted) {
      _endedCompleter.complete();
    }
    print('IsRemoved');
  }

  @override
  void onDetach() {
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
