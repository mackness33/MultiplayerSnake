import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/body_component.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';
import 'package:multiplayersnake/game/models/snake_controller.dart';

class SnakeComponent extends PositionComponent
    with HasGameRef<MultiplayerSnakeGame> {
  SnakeComponent(this.screen, this.board, this.tileSize)
      : snake = Snake(),
        speed = 1,
        delta = 0;

  final Rect screen;
  final BoardController board;
  final double tileSize;
  final Snake snake;
  final double speed;
  double delta;

  @override
  Future<void>? onLoad() async {
    print('in snake loading');
    await snake.initialize();
    await addAll(snake.body);
    print('in snake loaded');
  }

  @override
  void render(Canvas canvas) {
    // if (_snakeBody != null) {
    //   for (var part in _snakeBody.skip(1)) {
    //     part.render(canvas);
    //   }

    //   _snakeBody.first.render(canvas);
    // }
    super.render(canvas);
  }

  @override
  void update(double dt) {
    delta += dt;
    if (delta > speed) {
      snake.moveStraight();
      delta %= speed;
    }
    super.update(dt);
  }
}
