import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/views/play_view.dart';

// IDEA: add 'right' and 'left' to automatically move the body on the correct angle associated with it
enum BodyState { curve, straight }

class BodyComponent extends SpriteGroupComponent<BodyState>
    with HasGameRef<MultiplayerSnakeGame> {
  BodyComponent({
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

  @override
  Future<void>? onLoad() async {
    print('in body loading');
    final curveSprite = await gameRef.loadSprite('snake/body_curve.png');
    final straightSprite = await gameRef.loadSprite('snake/body.png');

    sprites = {
      BodyState.straight: straightSprite,
      BodyState.curve: curveSprite,
    };

    current = BodyState.straight;
    print('in body loaded');
  }
}
