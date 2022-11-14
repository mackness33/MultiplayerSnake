import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/game_manager.dart';
import 'package:multiplayersnake/utils/constants.dart';
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
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameStateFailed) {
          if (state.exception is GameGeneralException) {
            context.showErrorSnackBar(
                message: 'The game failed to start. Contact the developers!');
          }
        }
      },
      builder: (context, state) {
        print(state);
        if (state is GameStateConfigure) {
          return const LoadingView();
        } else if (state is GameStateLoad) {
          return const GameView();
        } else if (state is GameStateResume) {
          return const ResumeView();
        } else if (state is GameStateReady || state is GameStateFailed) {
          return const MenuView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
