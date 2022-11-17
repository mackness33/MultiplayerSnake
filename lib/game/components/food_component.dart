import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/collidable_component.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'dart:developer' as devtools;

class FoodComponent extends CollidableComponent {
  FoodComponent(
    this.name, {
    required Rect board,
    super.sprite,
    super.position,
    super.paint,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(hitOffset: Vector2(0, 0), colltype: CollisionType.passive);

  FoodComponent.random(
    this.name, {
    required Rect board,
    super.sprite,
    super.position,
    super.paint,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(hitOffset: Vector2(0, 0), colltype: CollisionType.passive) {
    final random = Random();
    position = Vector2(
        random.nextDouble() * board.width, random.nextDouble() * board.height);
  }

  FoodComponent.specialRandom(
    this.name, {
    required Rect board,
    super.sprite,
    super.position,
    super.paint,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) : super(hitOffset: Vector2(0, 0), colltype: CollisionType.passive) {
    final random = Random();

    switch (random.nextInt(4)) {
      case 0:
        position = Vector2(0, random.nextDouble() * board.height);
        break;
      case 1:
        position = Vector2(board.width, random.nextDouble() * board.height);
        break;
      case 2:
        position = Vector2(random.nextDouble() * board.width, 0);
        break;
      case 3:
        position = Vector2(random.nextDouble() * board.width, board.height);
        break;
    }
  }

  final String name;
}
