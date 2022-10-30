import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(const GameEventLoad());
            },
            child: const Text('Start')),
      ),
    );
  }
}
