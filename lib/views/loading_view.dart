import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_bloc.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_event.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_state.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<GameBloc>().add(
                  GameEventCreated(
                    SettingsService.screenSize(MediaQuery.of(context)),
                  ),
                );
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
