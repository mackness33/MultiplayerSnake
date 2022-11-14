import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:multiplayersnake/game/components/snake_component.dart';
import 'dart:ui';
import 'dart:developer' as devtools;
import 'package:multiplayersnake/game/ui/colors.dart';

class TapBoardComponent extends PositionComponent with TapCallbacks {
  TapBoardComponent(this.screen, this.tileSize)
      : super(size: Vector2(screen.width, screen.height));

  final Rect screen;
  final double tileSize;
  late final SnakeComponent player;

  @override
  Future<void>? onLoad() async {
    player = SnakeComponent(tileSize);
    await add(player);
    await super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    devtools.log('A TAPDOWN EVENT HAS HAPPEND!!!');
    devtools.log('Tap at local: ${event.localPosition}');
    devtools.log('Tap at canvas: ${event.canvasPosition}');
    devtools.log('Tap at device: ${event.devicePosition}');
    devtools.log('Tap at parent: ${event.parentPosition}');

    if (event.localPosition.x > screen.width / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
  }
}
