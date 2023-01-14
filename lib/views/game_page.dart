import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/socket/socket_service.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/game_views/resume_view.dart';
import 'package:multiplayersnake/views/game_views/game_view.dart';
import 'package:multiplayersnake/views/game_views/loading_view.dart';
import 'package:multiplayersnake/views/game_views/waiting_view.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameStateConfigurationFailed) {
          if (state.exception is RoomAlreadyExistedException) {
            context.showErrorSnackBar(
                message:
                    'The room already existed. Change the name and retry!');
          } else if (state.exception is RoomisFullException) {
            context.showErrorSnackBar(
                message:
                    'The room is full. Create a new room or join another room!');
          } else if (state.exception is RoomDoNotExistException) {
            context.showErrorSnackBar(
                message:
                    'The room doesn\'t exist. Create a new room or join another room!');
          } else if (state.exception is GeneralSocketException) {
            context.showErrorSnackBar(
                message:
                    'There has been an error with the server. Please retry. If the problem consist contact the developers');
          }
        }
      },
      buildWhen: (previous, current) {
        // print('In GamePage: $current');
        return current is GameStateUnactive || current is GameStateViewer;
      },
      builder: (context, state) {
        print('In GamePageBuilder: $state');
        if (state is GameStateConfigureInitialized) {
          return const LoadingView();
        } else if (state is GameStateStartWaiting) {
          return const WaitingView();
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
