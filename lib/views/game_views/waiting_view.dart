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
  late final GameRules _rules;
  late final Stream<List<String>> _waitingPlayersStream;
  late bool _isButtonDisabled;
  @override
  void initState() {
    if (context.read<GameBloc>().state is! GameStateStartWaiting) {
      context
          .read<GameBloc>()
          .add(GameEventFailed(Exception('Something went wrong')));
    } else {
      final gameState =
          (context.read<GameBloc>().state as GameStateStartWaiting);
      // streamPlayers = state.streamPlayers;
      _waitingPlayersStream = gameState.streamPlayers;
      _rules = gameState.rules;
    }
    _isButtonDisabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_rules.room)),
        actions: [
          if (_rules.isAdmin)
            IconButton(
              onPressed: () {
                context.read<GameBloc>().add(const GameEventLeft());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            rulesWidget(rules: _rules),
            playersWidget(
                rules: _rules, waitingPlayersStream: _waitingPlayersStream),
            if (_rules.player.isAdmin)
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          context.read<GameBloc>().add(
                                const GameEventReady(),
                              );
                        },
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 17.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget rulesWidget({required GameRules rules}) {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Rules',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ruleRow(
            title1: 'Max Players',
            value1: _rules.maxPlayers.toString(),
            title2: 'Max Time',
            value2: (_rules.maxTime == 0) ? '-' : _rules.maxTime.toString(),
          ),
          ruleRow(
            title1: 'Max Points',
            value1: (_rules.maxPoints == 0) ? '-' : _rules.maxPoints.toString(),
            title2: 'Public',
            value2: _rules.public.toString(),
          ),
        ],
      ),
    );
  }

  Widget rule({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17.5),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.indigo, fontSize: 20),
        ),
      ],
    );
  }

  Widget ruleRow({
    required String title1,
    required String value1,
    required String title2,
    required String value2,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          rule(
            title: title1,
            value: value1,
          ),
          rule(
            title: title2,
            value: value2,
          ),
        ],
      ),
    );
  }

  Widget playersWidget(
      {required GameRules rules,
      required Stream<List<String>> waitingPlayersStream}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Players',
              style: TextStyle(fontSize: 20),
            ),
          ),
          StreamBuilder<List<String>>(
            stream: waitingPlayersStream,
            initialData: rules.players.map((player) => player.email).toList(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                rules.updatePlayers(snapshot.data!.toSet());

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: rules.players.length,
                  itemBuilder: (context, index) {
                    return playerTile(
                        player: rules.players[index], amAdmin: rules.isAdmin);
                  },
                );
              }
              return const LinearProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget playerTile({required Player player, required bool amAdmin}) {
    return ListTile(
      // user room
      leading: player.isAdmin
          // ? const Text(
          //     'Admin',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          //   )
          ? const Icon(Icons.military_tech_outlined)
          : null,
      // message
      title: Text(
        player.email,
        style: TextStyle(
            fontSize: 15,
            // use different colors for different people
            color: player.isAdmin ? Colors.pink : Colors.blue),
      ),
      trailing: amAdmin && !player.isAdmin
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<GameBloc>().add(
                      GameEventRemovePlayer(player.email),
                    );
              },
            )
          : null,
    );
  }
}
