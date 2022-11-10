import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/models/board.dart';

class SnakeComponent extends SpriteComponent
    with HasGameRef<MultiplayerSnakeGame> {
  SnakeComponent(this.screen, this.board, this.tileSize);

  final Rect screen;
  final EntitySize board;
  final double tileSize;

  @override
  Future<void>? onLoad() async {
    print('in head loading');
    sprite = await gameRef.loadSprite('snake/head.png');
    width = tileSize;
    height = tileSize;
    anchor = Anchor.center;
    print('in head loaded');
  }

  // List<PositionComponent> _snakeBody;
}
