import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/collidable_component.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'dart:developer' as devtools;

class ExternalComponent extends CollidableComponent with CurveComponent {
  ExternalComponent(
    this.name, {
    required super.colltype,
    required super.sizeHit,
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

  ExternalComponent.head(
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
  }) : super(
          colltype: CollisionType.active,
          sizeHit: (size != null) ? size - Vector2(1, 1) : Vector2(0, 0),
        ) {
    curve = 0;
  }

  ExternalComponent.tail(
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
  }) : super.passive() {
    curve = 0;
  }

  final String name;
}
