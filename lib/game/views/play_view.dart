// import 'package:flame/components.dart';
// import 'package:flame/experimental.dart';
// import 'package:flame/image_composition.dart';
// import 'package:flutter/rendering.dart';
// import 'package:multiplayersnake/game/components/background_component.dart';
// import 'package:multiplayersnake/game/components/internal_component.dart';
// import 'package:multiplayersnake/game/components/snake_component.dart';
// import 'package:multiplayersnake/game/game.dart';

// class PlayView extends Component
//     with TapCallbacks, HasGameRef<MultiplayerSnakeGame> {
//   @override
//   Future<void> onLoad() async {
//     // addAll([
//     //   Background(const Color(0xff282828)),
//     //   TextBoxComponent(
//     //     text: '[Play]',
//     //     textRenderer: TextPaint(
//     //       style: const TextStyle(
//     //         color: Color.fromARGB(102, 234, 10, 10),
//     //         fontSize: 16,
//     //       ),
//     //     ),
//     //     align: Anchor.center,
//     //     size: gameRef.canvasSize,
//     //   ),
//     // ]);
//     // add(BodyComponent());
//     // add(SnakeComponent());
//   }

//   @override
//   bool containsLocalPoint(Vector2 point) => true;

//   @override
//   void onTapUp(TapUpEvent event) => onRemove();
// }
