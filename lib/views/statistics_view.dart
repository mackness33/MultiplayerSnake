import "package:flutter/material.dart";

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/services/database/database_service.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _MenuViewState();
}

class _MenuViewState extends State<StatisticsView> {
  late final TextEditingController _search;
  final GamesService _databaseService = GamesService();

  @override
  void initState() {
    _search = TextEditingController();
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
            FutureBuilder(
              future: _databaseService.getGames([]),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                      builder: ((context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allGames =
                                  snapshot.data as List<Map<String, dynamic>>;
                              devtools.log(allGames.toString());
                              return const Text('Got all the games');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      }),
                    );
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
