import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/views/resume_view.dart';
import 'package:multiplayersnake/views/game_view.dart';
import 'package:multiplayersnake/views/loading_view.dart';
import 'package:multiplayersnake/views/menu_view.dart';

import '../services/game/blocs/game_bloc.dart';
import '../services/game/blocs/game_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        print(state);
        if (state is GameStateLoading) {
          return const LoadingView();
        } else if (state is GameStateMounting) {
          return const GameView();
        } else if (state is GameStateResuming) {
          return const ResumeView();
        } else if (state is GameStateReady) {
          return const MenuView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
