import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:multiplayersnake/game/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final MultiplayerSnakeGame _game;

  @override
  void initState() {
    super.initState();
    _game = MultiplayerSnakeGame();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
