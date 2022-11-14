import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';

import '../services/game/blocs/game_bloc.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume')),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              print('in resume');
              context.read<GameBloc>().add(const GameEventEnded());
            },
            child: const Text('End')),
      ),
    );
  }
}
