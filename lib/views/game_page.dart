import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/resume_view.dart';
import 'package:multiplayersnake/views/game_view.dart';
import 'package:multiplayersnake/views/loading_view.dart';
import 'package:multiplayersnake/views/menu_view.dart';

import '../services/game/blocs/game_bloc.dart';
import '../services/game/blocs/game_state.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) {
        // print('In GamePage: $current');
        return current is GameStateUnactive || current is GameStateViewer;
      },
      builder: (context, state) {
        print('In GamePageBuilder: $state');
        if (state is GameStateConfigureInitialized) {
          return const LoadingView();
        } else if (state is GameStateStartLoaded) {
          return GameView(game: state.game);
        } else if (state is GameStateEndResults) {
          return const ResumeView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
