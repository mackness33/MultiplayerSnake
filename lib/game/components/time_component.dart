import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/game.dart';

class TimeComponent extends TextComponent
    with HasGameRef<MultiplayerSnakeGame> {
  TimeComponent(
    Vector2 position,
    this.duration, {
    super.size,
    super.scale,
    super.angle,
    super.children,
    super.priority,
  }) : super(
          text: '00:00',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Color.fromRGBO(20, 20, 20, 1.0),
            ),
          ),
          anchor: Anchor.center,
          position: position,
        );

  int duration;

  void tick() {
    duration--;
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    text = '$minutesStr:$secondsStr';

    if (duration == 0) {
      gameRef.end();
    }
  }
}
