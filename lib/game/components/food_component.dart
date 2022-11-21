import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/collidable_component.dart';
import 'dart:developer' as devtools;

class FoodComponent extends CollidableComponent {
  FoodComponent(
    this.name,
    this._point, {
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
  }) : super.passive();

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
  })  : _point = 100,
        super.passive() {
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
  })  : _point = 300,
        super.passive() {
    final random = Random();
    final width = board.width - size.x;
    final height = board.height - size.y;

    switch (random.nextInt(4)) {
      case 0:
        position = Vector2(0, random.nextDouble() * height);
        break;
      case 1:
        position = Vector2(width, random.nextDouble() * height);
        break;
      case 2:
        position = Vector2(random.nextDouble() * width, 0);
        break;
      case 3:
        position = Vector2(random.nextDouble() * width, height);
        break;
    }

    devtools.log('position: $position');
  }

  final String name;
  final int _point;

  int get point => _point;
}
