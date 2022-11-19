import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/collidable_group_component%20copy.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'package:multiplayersnake/game/game.dart';

enum BodyState { left, straight, right }

class InternalComponent extends CollidableGroupComponent<int>
    with CurveComponent, HasGameRef<MultiplayerSnakeGame> {
  InternalComponent({
    super.sprites,
    super.current,
    super.paint,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(hitOffset: Vector2(-2, -2)) {
    curve = 0;
  }

  @override
  Future<void>? onLoad() async {
    final rightSprite = await gameRef.loadSprite('snake/body_right.png');
    final straightSprite = await gameRef.loadSprite('snake/body.png');
    final leftSprite = await gameRef.loadSprite('snake/body_left.png');

    sprites = {
      -1: rightSprite,
      0: straightSprite,
      1: leftSprite,
    };

    current = 0;

    await add(RectangleHitbox(size: size - Vector2(2, 2))
      ..collisionType = CollisionType.passive);
  }

  @override
  void stir(int direction) {
    super.stir(direction);
    current = curve;
  }
}
