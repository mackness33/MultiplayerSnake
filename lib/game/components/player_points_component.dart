import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';

import 'dart:developer' as devtools show log;

class PlayerPointsComponent extends Component with HasGameRef {
  PlayerPointsComponent(this.board, this.color, this.position, this.player);

  final Rect board;
  final String player;
  late final TextComponent<TextPaint> pointsComponent;
  int _score = 0;
  final Color color;
  final Vector2 position;
  final Vector2 size = Vector2(30, 30);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await addAll([
      TextComponent(
        text: player,
        textRenderer: TextPaint(style: TextStyle(color: color)),
        anchor: Anchor.center,
        position: position - Vector2(0, size.y / 2),
        size: Vector2(30, 30),
      ),
      pointsComponent = TextComponent(
        text: _score.toString(),
        textRenderer: TextPaint(style: TextStyle(color: color)),
        anchor: Anchor.center,
        position: position + Vector2(0, size.y / 2),
        size: Vector2(30, 30),
      ),
    ]);
    devtools.log('Lets see: $hashCode');
  }

  @override
  void update(double dt) {
    pointsComponent.text = _score.toString();

    // if (player == 'davidantonhy962@gmail.com') {
    //   devtools.log(
    //       'PointsComponent: ${pointsComponent.text}, _score: $_score, points: $points');
    // }
    super.update(dt);
  }

  void updatePoints(bool isSpecial) {
    _score += (isSpecial ? 3 : 1);
    devtools.log('Actual points: $_score');
  }
}
