import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:multiplayersnake/game/components/external_component.dart';
import 'package:multiplayersnake/game/game.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';

class HeadComponent extends ExternalComponent
    with HasGameRef<MultiplayerSnakeGame>, CollisionCallbacks {
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
  }) : super(colltype: CollisionType.active) {
    curve = 0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    devtools.log('On collision of $name: $other at $intersectionPoints');
    super.onCollision(intersectionPoints, other);
    gameRef.end();
  }
}
