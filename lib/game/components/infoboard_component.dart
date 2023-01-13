import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/components/player_points_component.dart';
import 'package:multiplayersnake/game/components/time_component.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/services/game/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';

class PointsBoardComponent extends Component
    with HasGameRef<MultiplayerSnakeGame> {
  // with FlameBlocListenable<GameBloc, GameState> {
  // @override
  // bool listenWhen(GameState previousState, GameState newState) {
  //   return newState is GameStatePlayListening;
  // }

  // @override
  // void onNewState(GameState state) {
  //   devtools.log('In pointsBoardComponent');
  //   super.onNewState(state);
  //   subscription?.cancel();
  //   subscription = (state as GameStatePlayListening).streamPoints.listen(
  //         (data) =>
  //             pointsComponents[data['player']]?.updatePoints(data['isSpecial']),
  //       );

  //   devtools.log('getting the sub: $subscription');
  // }

  PointsBoardComponent(this.board);

  final Rect board;
  late final Map<String, PlayerPointsComponent> pointsComponents;
  // StreamSubscription? subscription;
  final List<Color> playersColor = <Color>[
    const Color.fromARGB(255, 24, 196, 53),
    const Color.fromARGB(255, 15, 39, 217),
    const Color.fromARGB(255, 211, 237, 15),
    const Color.fromARGB(255, 196, 41, 24)
  ];

  @override
  Future<void>? onLoad() async {
    TimeComponent timer;
    await super.onLoad();
    if (gameRef.gameRules.maxTime > 0) {
      await addAll([
        timer = TimeComponent(
          Vector2(board.width / 2, board.height / 2),
          gameRef.gameRules.maxTime * 60,
          size: Vector2(board.width / 6, board.height / 2),
        ),
        TimerComponent(period: 1, onTick: () => timer.tick(), repeat: true),
      ]);
    }
  }

  void addPlayers(List<String> players) {
    pointsComponents = Map<String, PlayerPointsComponent>.fromIterables(
        players, _buildPointsComponents(players));

    addAll(pointsComponents.values);
  }

  List<PlayerPointsComponent> _buildPointsComponents(List<String> players) {
    List<PlayerPointsComponent> points = <PlayerPointsComponent>[];
    double x = board.width / 6;
    double progressivePos = 0;
    for (int i = 0; i < players.length; i++) {
      points.add(
        PlayerPointsComponent(
          board,
          playersColor[i],
          Vector2(progressivePos += (i == 2) ? x * 2 : x, board.height / 2),
          players[i],
        ),
      );
    }

    return points;
  }

  // Future<void> end() async {
  //   devtools.log('ending subscription: $subscription');
  //   await subscription?.cancel();
  //   devtools.log('end subscription: $subscription');
  // }

  @override
  void render(Canvas canvas) {
    // voidBackground
    canvas.drawRect(Rect.fromLTWH(0, 0, board.width, board.height),
        Paint()..color = const Color.fromARGB(255, 9, 7, 95));
  }
}
