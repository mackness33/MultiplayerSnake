import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayersnake/game/components/curve_component.dart';
import 'package:multiplayersnake/game/utils/range.dart';

class ExternalComponent extends SpriteComponent with CurveComponent {
  ExternalComponent({
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
  }) {
    curve = 0;
  }
}
