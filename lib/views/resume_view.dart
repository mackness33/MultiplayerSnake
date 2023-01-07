import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';

import '../services/game/blocs/game_bloc.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  @override
  Widget build(BuildContext context) {
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
                  const Text('Hola'),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 5),
                  const Text('Rules'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('Max Time: 2 min'),
                      Text('Max Points : 2 pts'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('player 1: 10'),
                      Text('player 2: 25'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('player 3: 50'),
                      Text('player 4: 300'),
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
