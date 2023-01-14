import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/game_rules.dart';
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
  // late final Stream<Map<String, dynamic>> streamPlayers;
  late final Stream<List<String>> waitingPlayersStream;
  late bool _isButtonDisabled;
  @override
  void initState() {
    if (context.read<GameBloc>().state is! GameStateStartWaiting) {
      context
          .read<GameBloc>()
          .add(GameEventFailed(Exception('Something went wrong')));
    } else {
      final state = (context.read<GameBloc>().state as GameStateStartWaiting);
      // streamPlayers = state.streamPlayers;
      waitingPlayersStream = state.streamPlayers;
      rules = state.rules;
    }
    _isButtonDisabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rules.room),
        actions: [
          if (rules.isAdmin)
            IconButton(
              onPressed: () {
                context.read<GameBloc>().add(const GameEventLeft());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
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
            StreamBuilder<List<String>>(
              stream: waitingPlayersStream,
              initialData: rules.players.map((player) => player.email).toList(),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  // if (snapshot.data?["initial"] != null) {
                  //   if (snapshot.data!['isDeleted']) {
                  //     rules.addPlayer(snapshot.data!['player'], false);
                  //     setState(() {
                  //       _isButtonDisabled =
                  //           rules.players.length == rules.maxPlayers;
                  //     });
                  //   } else {
                  //     rules.removePlayer(snapshot.data!['player']);
                  //   }
                  // }

                  rules.updatePlayers(snapshot.data!.toSet());

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
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            : null,
                        // message
                        title: Text(
                          player.email,
                          style: TextStyle(
                              fontSize: 15,
                              // use different colors for different people
                              color:
                                  player.isAdmin ? Colors.pink : Colors.blue),
                        ),
                        trailing: rules.isAdmin && !player.isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context.read<GameBloc>().add(
                                        GameEventRemovePlayer(player.email),
                                      );
                                },
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
                      onPressed: _isButtonDisabled
                          ? null
                          : () {
                              context.read<GameBloc>().add(
                                    const GameEventReady(),
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
