import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'dart:ui';
import 'dart:developer' as devtools;
import 'package:multiplayersnake/game/ui/colors.dart';

class TapBoardComponent extends PositionComponent with TapCallbacks {
  TapBoardComponent(this.screen)
      : super(size: Vector2(screen.width, screen.height));

  final Rect screen;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    devtools.log('A TAPDOWN EVENT HAS HAPPEND!!!');
    devtools.log('Tap at local: ${event.localPosition}');
    devtools.log('Tap at canvas: ${event.canvasPosition}');
    devtools.log('Tap at device: ${event.devicePosition}');
    devtools.log('Tap at parent: ${event.parentPosition}');
  }
}
