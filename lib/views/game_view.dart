import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final MultiplayerSnakeGame _game;

  @override
  void initState() {
    super.initState();
    _game = MultiplayerSnakeGame();
  }

  @override
  Widget build(BuildContext context) {
    context.read<GameBloc>().add(const GameEventPlay());
    return GameWidget(game: _game);
  }
}
