import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayersnake/game/components/background_component.dart';
import 'package:multiplayersnake/game/game.dart';

class ResumeView extends Component
    with TapCallbacks, HasGameRef<MultiplayerSnakeGame> {
  @override
  Future<void> onLoad() async {
    addAll([
      Background(const Color(0xff282828)),
      TextBoxComponent(
        text: '[Resume]',
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color.fromARGB(102, 234, 10, 10),
            fontSize: 16,
          ),
        ),
        align: Anchor.center,
        size: gameRef.canvasSize,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => gameRef.router.pushNamed('splash-screen');
}
