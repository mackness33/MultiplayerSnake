import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:multiplayersnake/game/components/body_component.dart';
import 'package:multiplayersnake/game/game.dart';

class Snake {
  final List<PositionComponent> _body;

  Snake() : _body = List.empty(growable: true);

  Future<void>? initialize(double tileSize) async {
    final SpriteComponent head = SpriteComponent.fromImage(
      await Flame.images.load('snake/head.png'),
      size: Vector2(tileSize, tileSize),
      position: Vector2(200, 200 - tileSize),
    );
    final BodyComponent body = BodyComponent(
      size: Vector2(tileSize, tileSize),
      position: Vector2(200, 200),
    );
    final SpriteComponent tail = SpriteComponent.fromImage(
      await Flame.images.load('snake/tail.png'),
      size: Vector2(tileSize, tileSize),
      position: Vector2(200, 200 + tileSize),
    );

    _body.addAll([tail, body, head]);
  }

  List<PositionComponent> get body => _body;
}
