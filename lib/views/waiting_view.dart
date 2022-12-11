import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';

class WaitingView extends StatefulWidget {
  const WaitingView({super.key});

  @override
  State createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  // This list holds the conversation
  // the ChatMessage class was declared above
  final List<Player> _players = [];
  GameRules? rules;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = (context.read<GameBloc>().state as GameStateStartWaiting);
    final Stream<Map<String, dynamic>> streamPlayers = state.streamPlayers;
    rules = state.rules;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Waiting')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: streamPlayers,
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!['isDeleted']) {
                    _players.add(Player.basic(snapshot.data!['player']));
                  } else {
                    _players.remove(Player.basic(snapshot.data!['player']));
                  }

                  return ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      final Player player = _players[index];
                      return ListTile(
                        // user name
                        leading: player.isAdmin
                            ? const Text(
                                'Admin',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            : null,
                        // message
                        title: Text(
                          player.email,
                          style: TextStyle(
                              fontSize: 20,
                              // use different colors for different people
                              color:
                                  player.isAdmin ? Colors.pink : Colors.blue),
                        ),
                      );
                    },
                  );
                }
                return const LinearProgressIndicator();
              },
            ),
            (rules!.player.isAdmin)
                ? Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(
                              const GameEventStarted([]),
                            );
                      },
                      child: const Text('Play'),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
