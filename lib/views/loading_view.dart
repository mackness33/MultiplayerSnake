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
    context.read<SocketBloc>().add(const SocketEventConnection());

    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: Center(
        child: BlocConsumer<SocketBloc, SocketState>(
          builder: ((context, state) {
            print(state);
            if (state is SocketStateReady) {
              return ElevatedButton(
                onPressed: () {
                  final Rect screen =
                      SettingsService.screenSize(MediaQuery.of(context));
                  context.read<GameBloc>().add(GameEventConfigured(screen));
                },
                child: const Text('Start'),
              );
            } else {
              return const Text(
                  'The socket is not connected, check your connection');
            }
          }),
          listener: ((context, state) {}),
        ),
      ),
    );
  }
}
