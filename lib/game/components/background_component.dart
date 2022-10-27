import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

class Background extends Component {
  Background(this.color);

  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}
