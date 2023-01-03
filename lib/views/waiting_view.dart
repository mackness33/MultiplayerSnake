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
  late final GameRules rules;
  late final Stream<Map<String, dynamic>> streamPlayers;

  @override
  void initState() {
    if (context.read<GameBloc>().state is! GameStateStartWaiting) {
      context
          .read<GameBloc>()
          .add(GameEventFailed(Exception('Something went wrong')));
    } else {
      final state = (context.read<GameBloc>().state as GameStateStartWaiting);
      streamPlayers = state.streamPlayers;
      rules = state.rules;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rules.room),
        actions: [
          IconButton(
              onPressed: () {
                context.read<GameBloc>().add(const GameEventLeft());
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text('RULES'),
            // Column(
            //   children: [
            Text('Max Players: ${rules.maxPlayers}'),
            const SizedBox(height: 10),
            Text('Max Time: ${rules.maxTime}'),
            const SizedBox(height: 10),
            Text('Max Points: ${rules.maxPoints}'),
            const SizedBox(height: 10),
            Text('Public: ${rules.public}'),
            //   ],
            // ),
            const SizedBox(height: 30),
            StreamBuilder(
              stream: streamPlayers,
              initialData: const <String, dynamic>{"initial": null},
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?["initial"] != null) {
                    if (snapshot.data!['isDeleted']) {
                      rules.addPlayer(snapshot.data!['player'], false);
                    } else {
                      rules.removePlayer(snapshot.data!['player']);
                    }
                  }

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: rules.players.length,
                    itemBuilder: (context, index) {
                      final Player player = rules.players[index];
                      return ListTile(
                        // user room
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
                        trailing: !player.isAdmin
                            ? TextButton.icon(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context.read<GameBloc>().add(
                                        GameEventDeletePlayer(
                                            player.email, rules.room),
                                      );
                                },
                                label: Container(),
                              )
                            : null,
                      );
                    },
                  );
                }
                return const LinearProgressIndicator();
              },
            ),
            const SizedBox(height: 30),
            (rules.player.isAdmin)
                ? Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(
                              GameEventReady(),
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
