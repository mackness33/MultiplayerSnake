import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/external_component.dart';
import 'dart:developer' as devtools;

class HeadComponent extends ExternalComponent with CollisionCallbacks {
  HeadComponent(
    super.name, {
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
    colltype = CollisionType.active;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    devtools.log('On collision of $name: $other at $intersectionPoints');
    super.onCollision(intersectionPoints, other);
  }
}
