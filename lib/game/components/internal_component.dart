import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'package:multiplayersnake/game/game.dart';
import 'dart:developer' as devtools;

enum BodyState { left, straight, right }

class InternalComponent extends SpriteGroupComponent<int>
    with CurveComponent, HasGameRef<MultiplayerSnakeGame> {
  InternalComponent(
    this.name, {
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
  }) {
    curve = 0;
  }

  final String name;

  late final RectangleHitbox hitbox;

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

    hitbox =
        RectangleHitbox(size: size, position: size / 2, anchor: Anchor.center)
          ..isSolid = true
          ..collisionType = CollisionType.passive;
    await add(hitbox);
    await super.onLoad();
  }

  @override
  void stir(int direction) {
    super.stir(direction);
    current = curve;
  }
}
