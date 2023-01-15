import 'package:flutter/material.dart';
import 'package:multiplayersnake/services/database/database_game.dart';

Widget gameCard({required DatabaseGame game, required List<Widget> rules}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    child: Card(
      child: Column(
        children: [
          titleWidget(isWinner: game.user.isWinner, title: game.name),
          bodyWidget(game: game, rows: rules),
        ],
      ),
    ),
  );
}

Widget titleWidget({
  required bool isWinner,
  required String title,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      color:
          isWinner ? Colors.green.shade700 : Colors.deepOrangeAccent.shade700,
    ),
    child: Center(
        child: Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    )),
  );
}

Widget bodyWidget({
  required DatabaseGame game,
  required List<Widget> rows,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      color: game.user.isWinner
          ? const Color.fromARGB(152, 56, 142, 60)
          : const Color.fromARGB(152, 221, 44, 0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child:
              Center(child: ruleWidget(title: 'ID', value: game.id.toString())),
        ),
        // ruleWidget(title: 'ID', value: game.id.toString()),
        const Divider(),
        rulesWidget(rows: rows, title: 'Rules'),
        const Divider(),
        playersWidget(game: game),
      ],
    ),
  );
}

Widget rulesWidget({required List<Widget> rows, required String title}) {
  List<Widget> widgets = <Widget>[
    Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    ),
  ];
  widgets.addAll(rows);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: widgets,
    ),
  );
}

Widget ruleWidget({required String title, required String value}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
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
        style: const TextStyle(fontSize: 20),
      ),
    ],
  );
}

Widget ruleRow({required List<Widget> rules}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: rules,
    ),
  );
}

Widget playersWidget({required DatabaseGame game}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    child: Column(
      children: [
        const Center(
          child: Text(
            'Players',
            style: TextStyle(fontSize: 20),
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: game.players.length,
          itemBuilder: (context, index) {
            return playerTile(
              player: game.players[index],
              // amUser: game.players[index].email == game.user.email,
              amUser: game.index == index,
            );
          },
        ),
      ],
    ),
  );
}

Widget playerTile({required DatabasePlayer player, required bool amUser}) {
  return ListTile(
    leading: (player.isWinner) ? const Icon(Icons.hail) : null,
    title: Text(
      player.email,
      style: TextStyle(
          fontSize: 15,
          // use different colors for different people
          color: amUser ? Colors.pink : Colors.blue),
    ),
    trailing: Text(
      player.points.toString(),
      style: TextStyle(
          fontSize: 15,
          // use different colors for different people
          color: amUser ? Colors.pink : Colors.blue),
    ),
  );
}
