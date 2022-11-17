import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:developer' as devtools;

class CollidableComponent extends SpriteComponent {
  CollidableComponent({
    required this.colltype,
    required this.hitOffset,
    super.sprite,
    super.paint,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  });

  CollidableComponent.passive({
    required this.hitOffset,
    super.sprite,
    super.paint,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) : colltype = CollisionType.passive;

  final CollisionType colltype;
  final Vector2 hitOffset;

  @override
  Future<void>? onLoad() async {
    // need to sub V2(2,2) because otherwise while making a U turn a collision
    // will take place with the internal and external parts
    await add(
        RectangleHitbox(size: size + hitOffset)..collisionType = colltype);
    await super.onLoad();
  }
}
