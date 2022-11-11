import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:multiplayersnake/game/components/body_component.dart';
import 'package:multiplayersnake/game/game.dart';

enum direction { up, down, right, left }

class Snake {
  final List<PositionComponent> _body;
  final double tileSize;
  int direction;

  Snake()
      : _body = List.empty(growable: true),
        tileSize = 10,
        direction = 0;

  Future<void>? initialize() async {
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

  // List<PositionComponent> _getBodyReversedListWithoutHead() {
  //   return _getReversedListWithoutHead().toList();
  // }

  Iterable<PositionComponent> _getReversedListWithoutHead() {
    return _body.skip(1).toList().reversed;
  }

  // List<PositionComponent> _getBodyReversedListWithoutTail() {
  //   return _getReversedListWithoutTail().toList();
  // }

  Iterable<PositionComponent> _getReversedListWithoutTail() {
    return _body.reversed.skip(1);
  }

  void _move(Vector2 trasition) {
    // print(_body.reversed.toString());
    // print(_body.reversed.iterator.toString());
    // print(_body.reversed.iterator.current.toString());
    final next = _body.reversed.iterator;
    next.moveNext();
    // print(next.current);
    PositionComponent current = next.current;

    while (next.moveNext()) {
      current.position = next.current.position;
      current = next.current;
    }

    // it supposed to be the head
    current.position += trasition;
  }

  // direction: 0: top, 1: right, 2: buttom, 3: left, default: nothing
  void _moveTo(int direction) {
    print('moving');
    switch (direction) {
      case 0:
        _move(_body.first.position + Vector2(0, tileSize));
        break;
      case 1:
        _move(_body.first.position + Vector2(tileSize, 0));
        break;
      case 2:
        _move(_body.first.position + Vector2(0, -tileSize));
        break;
      case 3:
        _move(_body.first.position + Vector2(-tileSize, 0));
        break;
      default:
    }
  }

  void moveRight() => _moveTo(++direction);
  void moveStraight() => _moveTo(direction);
  void moveLeft() => _moveTo(--direction);

  List<PositionComponent> get body => _body;
}
