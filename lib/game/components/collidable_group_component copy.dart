import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/utils/range.dart';
import 'package:multiplayersnake/game/views/play_view.dart';

enum BodyState { left, straight, right }

class CollidableGroupComponent<T> extends SpriteGroupComponent<T> {
  CollidableGroupComponent({
    required this.hitOffset,
    super.sprites,
    super.current,
    super.paint,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  });

  final Vector2 hitOffset;

  @override
  Future<void>? onLoad() async {
    // need to sub V2(2,2) because otherwise while making a U turn a collision
    // will take place with the internal and external parts
    await add(RectangleHitbox(size: size + hitOffset)
      ..collisionType = CollisionType.passive);
    await super.onLoad();
  }
}
