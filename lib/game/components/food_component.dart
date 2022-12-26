import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multiplayersnake/game/components/collidable_component.dart';
import 'dart:developer' as devtools;

class FoodComponent extends CollidableComponent {
  FoodComponent(
    this.name,
    this._point,
    this._boardHeight,
    this._boardWidth,
    this._isSpecial, {
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
    super.paint,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  })  : _point = 1,
        _boardHeight = board.height - (size?.y ?? 0),
        _boardWidth = board.width - (size?.x ?? 0),
        _isSpecial = false,
        super.passive() {
    position = _randomPosition();
  }

  FoodComponent.specialRandom(
    this.name, {
    required Rect board,
    super.sprite,
    super.paint,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  })  : _point = 3,
        _boardHeight = board.height - (size?.y ?? 0),
        _boardWidth = board.width - (size?.x ?? 0),
        _isSpecial = true,
        super.passive() {
    position = _specialRandomPosition();
  }

  final String name;
  final int _point;
  final double _boardWidth;
  final double _boardHeight;
  final bool _isSpecial;
  bool get isSpecial => _isSpecial;

  void changePosition() =>
      position = (isSpecial) ? _specialRandomPosition() : _randomPosition();

  Vector2 _specialRandomPosition() {
    final random = Random();

    switch (random.nextInt(4)) {
      case 0:
        return Vector2(0, random.nextDouble() * _boardHeight);
      case 1:
        return Vector2(_boardWidth, random.nextDouble() * _boardHeight);
      case 2:
        return Vector2(random.nextDouble() * _boardWidth, 0);
      case 3:
        return Vector2(random.nextDouble() * _boardWidth, _boardHeight);

      default:
        return Vector2(0, 0);
    }
  }

  Vector2 _randomPosition() {
    final random = Random();
    return Vector2(
        random.nextDouble() * _boardWidth, random.nextDouble() * _boardHeight);
  }

  int get point => _point;
}
