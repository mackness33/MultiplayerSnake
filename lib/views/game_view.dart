import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:multiplayersnake/game/game.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.game});

  final MultiplayerSnakeGame game;

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}

// class GameView extends StatefulWidget {
//   const GameView({super.key});

//   @override
//   State createState() => _GameViewState();
// }

// class _GameViewState extends State<GameView> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
