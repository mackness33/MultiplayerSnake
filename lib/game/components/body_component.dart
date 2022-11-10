import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/game/views/play_view.dart';

enum BodyState { curve, straight }

class BodyComponent extends SpriteGroupComponent<BodyState>
    with HasGameRef<MultiplayerSnakeGame> {
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
