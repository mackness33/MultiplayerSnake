import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<GameBloc>().add(const GameEventPlayed());
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) => current is GameStateLoad,
      builder: (context, state) {
        if (state is GameStateLoad) {
          print('after loading in the play view');
          return GameWidget(game: state.game);
        }
        return Scaffold(
          body: Center(child: Text('Error on the BLoC. State: $state')),
        );
      },
    );
  }
}
