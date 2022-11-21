import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:developer' as devtools;

import 'package:flutter/painting.dart';

class CollidableComponent extends SpriteComponent {
  CollidableComponent({
    required this.colltype,
    required this.sizeHit,
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
  })  : colltype = CollisionType.passive,
        sizeHit = size ?? Vector2(0, 0);

  final CollisionType colltype;
  final Vector2 sizeHit;
  late final RectangleHitbox hitbox;

  @override
  Future<void>? onLoad() async {
    // need to sub V2(2,2) because otherwise while making a U turn a collision
    // will take place with the internal and external parts
    hitbox = RectangleHitbox(
      size: sizeHit,
      position: size / 2,
      anchor: Anchor.center,
    )
      ..collisionType = colltype
      ..isSolid = true;
    await add(hitbox);
    await super.onLoad();
  }
}
