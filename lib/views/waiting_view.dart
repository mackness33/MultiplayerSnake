import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';

class WaitingView extends StatefulWidget {
  const WaitingView({super.key});

  @override
  State createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Waiting')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(
                      const GameEventStarted([]),
                    );
              },
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
