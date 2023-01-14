import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/services/socket/socket_service.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/game_page.dart';
import 'package:multiplayersnake/views/menu_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (previous, current) => current is GameStateFailed,
      listener: (context, state) {
        if (state is GameStateFailed) {
          if (state.exception is GameGeneralException) {
            context.showErrorSnackBar(
                message: 'The game failed to start. Contact the developers!');
          } else if (state.exception is ConnectionTimeoutException) {
            context.showErrorSnackBar(
                message:
                    'The game failed to connect to the server. Check your connection or contact the developers!');
          } else if (state.exception is ExceededMaximumTimeException) {
            context.showErrorSnackBar(
                message: 'Time to play exceeded the maximum time.');
          }
        }
      },
      buildWhen: (previous, current) {
        // print('In MenuPageWhen: $current');
        return (current is GameStateReadyDisconnected) ||
            current is GameStateReadyConnecting ||
            current is GameStateFailed ||
            current is GameStateConfigureInitialized;
      },
      builder: (context, state) {
        print('In MenuPageBuilder: $state');
        if (state is GameStateReadyDisconnected || state is GameStateFailed) {
          return const MenuView();
        } else {
          return const GamePage();
        }
      },
    );
  }
}
