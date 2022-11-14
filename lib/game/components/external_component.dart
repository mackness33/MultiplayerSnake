import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'dart:developer' as devtools;

class ExternalComponent extends SpriteComponent with CurveComponent {
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
    colltype = CollisionType.passive;
  }

  final String name;
  late CollisionType colltype;

  @override
  Future<void>? onLoad() async {
    // need to sub V2(2,2) because otherwise while making a U turn a collision
    // will take place with the internal and external parts
    await add(
        RectangleHitbox(size: size - Vector2(2, 2))..collisionType = colltype);
    await super.onLoad();
  }
}
