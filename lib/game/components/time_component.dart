import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

class TimeComponent extends Component {
  TimeComponent(this.board, this.position);

  final Rect board;
  final Vector2 position;
  final Vector2 size = Vector2(30, 30);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(TextComponent(
      text: '00:00',
      textRenderer: TextPaint(
          style: const TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0))),
      anchor: Anchor.center,
      position: position - Vector2(0, size.y / 2),
      size: Vector2(30, 30),
    ));
  }
}
