import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/services/game_orchestrator.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_bloc.dart';
import 'package:multiplayersnake/services/socket/socket_manager.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/game_page.dart';
import 'package:multiplayersnake/views/resume_view.dart';
import 'package:multiplayersnake/views/game_view.dart';
import 'package:multiplayersnake/views/loading_view.dart';
import 'package:multiplayersnake/views/menu_view.dart';

import '../services/game/blocs/game_bloc.dart';
import '../services/game/blocs/game_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SocketManager socketManager;

  @override
  void initState() {
    super.initState();
    socketManager = SocketManager();
  }

  @override
  void dispose() {
    // TODO: the socketManager must have a dispose method
    // socketManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (previous, current) => current is GameStateFailed,
      listener: (context, state) {
        if (state is GameStateFailed) {
          if (state.exception is GameGeneralException) {
            context.showErrorSnackBar(
                message: 'The game failed to start. Contact the developers!');
          }
        }
      },
      buildWhen: (previous, current) {
        // print('In MenuPageWhen: $current');
        return (previous is GameStateEndRemoving &&
                current is GameStateReadyDisconnected) ||
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
