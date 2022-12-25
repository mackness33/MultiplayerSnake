import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:multiplayersnake/game/models/board_controller.dart';

class PlayerPointsComponent extends Component {
  PlayerPointsComponent(this.board, this.color, this.position);

  final Rect board;
  late final TextComponent<TextPaint> player;
  late TextComponent<TextPaint> points;
  final Color color;
  final Vector2 position;
  final Vector2 size = Vector2(30, 30);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    player = TextComponent(
      text: 'player',
      textRenderer: TextPaint(style: TextStyle(color: color)),
      anchor: Anchor.center,
      position: position - Vector2(0, size.y / 2),
      size: Vector2(30, 30),
    );
    points = TextComponent(
      text: '0',
      textRenderer: TextPaint(style: TextStyle(color: color)),
      anchor: Anchor.center,
      position: position + Vector2(0, size.y / 2),
      size: Vector2(30, 30),
    );
    await addAll([
      player,
      points,
    ]);
  }
}
