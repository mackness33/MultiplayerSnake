import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_state.dart';
import 'package:multiplayersnake/services/game/game_resume.dart';

import '../services/game/blocs/game_bloc.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  @override
  Widget build(BuildContext context) {
    final GameResume resume =
        (context.read<GameBloc>().state as GameStateEndResults).resume;
    return Scaffold(
      appBar: AppBar(title: const Text('Resume')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(resume.name),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 5),
                  const Text('Rules'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Max Time: ${resume.maxTime} min'),
                      const Text('Max Points: 2 pts'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${resume.player0}: ${resume.points0}'),
                      Text('${resume.player1}: ${resume.points1}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${resume.player2}: ${resume.points2}'),
                      Text('${resume.player3}: ${resume.points3}'),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
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
