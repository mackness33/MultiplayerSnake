import 'package:flame/components.dart';
import 'package:multiplayersnake/game/game.dart';

class SnakeComponent extends SpriteComponent
    with HasGameRef<MultiplayerSnakeGame> {
  // SnakeComponent(this.tileSize);

  // final double tileSize;

  @override
  Future<void>? onLoad() async {
    print('in head loading');
    sprite = await gameRef.loadSprite('snake/head.png');
    width = 200;
    height = 200;
    anchor = Anchor.center;
    print('in head loaded');
  }

  // List<PositionComponent> _snakeBody;
}
