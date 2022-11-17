import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:multiplayersnake/game/components/food_component.dart';
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
  late final FoodComponent basicFood;
  late final FoodComponent specialFood;

  @override
  Future<void>? onLoad() async {
    player = SnakeComponent(tileSize);
    basicFood = FoodComponent.random(
      'basic',
      sprite: Sprite(await Flame.images.load('food/food.png')),
      board: screen,
      size: Vector2(tileSize, tileSize),
    );
    specialFood = FoodComponent.specialRandom(
      'special',
      sprite: Sprite(await Flame.images.load('food/red_food.png')),
      board: screen,
      size: Vector2(tileSize, tileSize),
    );
    await add(RectangleHitbox()..collisionType = CollisionType.active);
    await add(player);
    await add(basicFood);
    await add(specialFood);
    await super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // devtools.log('A TAPDOWN EVENT HAS HAPPEND!!!');
    // devtools.log('Tap at local: ${event.localPosition}');
    // devtools.log('Tap at canvas: ${event.canvasPosition}');
    // devtools.log('Tap at device: ${event.devicePosition}');
    // devtools.log('Tap at parent: ${event.parentPosition}');

    if (event.localPosition.x > screen.width / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
  }
}
