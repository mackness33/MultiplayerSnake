import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/utils/game_card.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  @override
  Widget build(BuildContext context) {
    final DatabaseGame resume =
        (context.read<GameBloc>().state as GameStateEndResults).resume;
    return Scaffold(
      appBar: AppBar(title: const Text('Resume')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gameCard(
              game: resume,
              rules: <Widget>[
                ruleRow(
                  rules: <Widget>[
                    ruleWidget(
                      title: 'Max Points',
                      // value: (game.maxPoints == 0)
                      //     ? '-'
                      //     : game.maxPoints.toString(),
                      value: '-',
                    ),
                    ruleWidget(
                      title: 'Max Time',
                      value: (resume.maxTime == 0)
                          ? '-'
                          : resume.maxTime.toString(),
                    ),
                  ],
                ),
                ruleRow(
                  rules: <Widget>[
                    ruleWidget(
                      title: 'Public',
                      // value: (game.maxPoints == 0)
                      //     ? '-'
                      //     : game.maxPoints.toString(),
                      value: '-',
                    ),
                    ruleWidget(
                      title: 'Total players',
                      value: resume.players.length.toString(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(const GameEventEnded());
              },
              child: const Text('End'),
            ),
          ],
        ),
      ),
    );
  }
}
