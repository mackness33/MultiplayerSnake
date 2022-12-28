import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';

class PlayerPointsComponent extends Component {
  PlayerPointsComponent(this.board, this.color, this.position, this.player);

  final Rect board;
  final String player;
  late final TextComponent<TextPaint> pointsComponent;
  int _points = 0;
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
        text: _points.toString(),
        textRenderer: TextPaint(style: TextStyle(color: color)),
        anchor: Anchor.center,
        position: position + Vector2(0, size.y / 2),
        size: Vector2(30, 30),
      ),
    ]);
  }

  void updatePoints(bool isSpecial) =>
      pointsComponent.text = (_points += (isSpecial ? 3 : 1)).toString();
}
