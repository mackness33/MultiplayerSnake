// import 'dart:math';

// import 'package:flame/components.dart';
// import 'package:flame/flame.dart';
// import 'package:multiplayersnake/game/components/curve_component.dart';
// import 'package:multiplayersnake/game/components/external_component.dart';
// import 'package:multiplayersnake/game/components/internal_component.dart';
// import 'package:multiplayersnake/game/utils/range.dart';
// // import 'dart:developer' as devtools;

// enum CurveState { left, straight, right }

// class Snake {
//   final List<PositionComponent> _body;
//   final double tileSize;
//   RangeWithHistory direction;

//   Snake(this.tileSize)
//       : _body = List.empty(growable: true),
//         direction = RangeWithHistory(2, 4);

//   Future<void>? initialize() async {
//     final ExternalComponent head = ExternalComponent(
      
//       sprite: Sprite(await Flame.images.load('snake/head.png')),
//       size: Vector2(tileSize, tileSize),
//       position: Vector2(200, 200 - tileSize),
//       anchor: Anchor.center,
//     );
//     final InternalComponent body = InternalComponent(
//       size: Vector2(tileSize, tileSize),
//       position: Vector2(200, 200),
//       anchor: Anchor.center,
//     );
//     final ExternalComponent tail = ExternalComponent(
//       sprite: Sprite(await Flame.images.load('snake/tail.png')),
//       size: Vector2(tileSize, tileSize),
//       position: Vector2(200, 200 + tileSize),
//       anchor: Anchor.center,
//     );

//     _body.addAll([head, body, tail]);
//   }

//   void _move(Vector2 trasition) {
//     final difference = _betterDifference(direction.difference);
//     // iterate from the tail until the head (not included)
//     Iterator<PositionComponent> next = _body.reversed.iterator;
//     // move to the tail
//     next.moveNext();
//     // component of the tail
//     PositionComponent current = next.current;

//     // move until the head of the snake
//     while (next.moveNext()) {
//       current.position = next.current.position;
//       current.angle = next.current.angle;
//       if (current is InternalComponent) {
//         current.stir((next.current as CurveComponent).curve);
//       } else {
//         (current as CurveComponent)
//             .stir((next.current as CurveComponent).curve);
//       }
//       current = next.current;
//     }

//     // make the head move and rotate to the new direction
//     (_body[1] as CurveComponent).stir(difference);
//     _body.last.angle = _body[_body.length - 2].angle;

//     current.position += trasition;
//     current.angle += difference * (pi / 2);
//     (current as CurveComponent).stir(difference);
//   }

//   // direction: 0: buttom, 1: left, 2: top, 3: right, default: nothing
//   void move() {
//     switch (direction.current) {
//       case 0:
//         _move(Vector2(0, tileSize));
//         break;
//       case 1:
//         _move(Vector2(tileSize, 0));
//         break;
//       case 2:
//         _move(Vector2(0, -tileSize));
//         break;
//       case 3:
//         _move(Vector2(-tileSize, 0));
//         break;
//       default:
//     }

//     direction.keep();
//   }

//   int _betterDifference(int difference) {
//     if ((difference / 2).abs() > 1) {
//       return (difference % 2) * -difference.sign;
//     }

//     return difference;
//   }

//   void moveRight() => direction.absDecrease();
//   void moveLeft() => direction.absIncrease();

//   List<PositionComponent> get body => _body;
// }
