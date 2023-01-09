import 'package:flutter/material.dart';
import 'package:multiplayersnake/services/database/database_game.dart';

Card gameCard(DatabaseGame game) {
  return Card(
    child: Column(
      children: [
        const SizedBox(height: 15),
        Text(game.name),
        const SizedBox(height: 5),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(height: 5),
        Text('ID: ${game.id}'),
        const SizedBox(height: 10),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(height: 5),
        const Text('Rules'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Max Time: ${game.maxTime} min'),
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
            Text('${game.player0}: ${game.points0}'),
            Text('${game.player1}: ${game.points1}'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${game.player2}: ${game.points2}'),
            Text('${game.player3}: ${game.points3}'),
          ],
        ),
        const SizedBox(height: 15),
      ],
    ),
  );
}
