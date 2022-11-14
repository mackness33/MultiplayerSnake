import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'package:multiplayersnake/game/ui/colors.dart';
import 'package:multiplayersnake/game/utils/range.dart';
import 'dart:developer' as devtools;

class ExternalComponent extends SpriteComponent
    with CurveComponent, CollisionCallbacks {
  ExternalComponent(
    this.name, {
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
  }) {
    curve = 0;
  }

  final String name;

  @override
  Future<void>? onLoad() async {
    // need to sub V2(1,1) because otherwise while turning the head/tail it will hit
    // the angle of the part after the adjacent part of the head/tail
    await add(RectangleHitbox(size: size - Vector2(1, 1)));
    await super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    devtools.log('On collision of $name: $other at $intersectionPoints');
    super.onCollision(intersectionPoints, other);
  }
}
