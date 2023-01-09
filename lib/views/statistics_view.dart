import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_games_service.dart';

import "dart:developer" as devtools show log;

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  late final TextEditingController _search;
  final DatabaseGamesService _databaseService = DatabaseGamesService();

  @override
  void initState() {
    _search = TextEditingController();
    _databaseService.init();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    devtools.log('Select Filters');
                  },
                  child: const Text('Filters'),
                ),
                Expanded(
                  child: TextField(
                    obscureText: true,
                    controller: _search,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    devtools.log('Search');
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
            StreamBuilder(
              stream: _databaseService.allGames,
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allGames = snapshot.data as List<DatabaseGame>;
                      devtools.log(allGames.toString());
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: allGames.length,
                        itemBuilder: (context, index) {
                          return const Text('item');
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
