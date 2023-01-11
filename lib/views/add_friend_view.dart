import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_friends_service.dart';
import 'package:multiplayersnake/services/database/database_games_service.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/services/database/database_profiles_service.dart';

class AddFriendsView extends StatefulWidget {
  const AddFriendsView({super.key});

  @override
  State<AddFriendsView> createState() => _AddFriendsViewState();
}

class _AddFriendsViewState extends State<AddFriendsView> {
  final DatabaseFriendsService _databaseService = DatabaseFriendsService();
  late final TextEditingController _search;

  @override
  void initState() {
    _databaseService.init();
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
        title: const Text("Add Friends"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _databaseService.searchPlayer(_search.text);
                        },
                        child: const Text('Search'))
                  ],
                ),
                StreamBuilder(
                    stream: _databaseService.searchedPlayers,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container();
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final List<DatabaseFriend> players =
                                snapshot.data as List<DatabaseFriend>;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: players.length,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  title: Text(
                                    players[index].followedEmail ?? 'Not Found',
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      devtools.log('Added!');
                                      _databaseService.addFriend(
                                          id: players[index].followed);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    }),
              ],
            )),
      ),
    );
  }
}

const List<String> titles = <String>['Email', 'Website', 'Full Name'];
const List<String> infos = <String>[
  'palmeiro.leonardo@gmail.com',
  'https://github.com/leopalmeiro',
  'www.linkedin.com/in/leonardo-palmeiro-834a1755'
];
const avatarUrlKey = 'avatar_url';
const websiteKey = 'website';
const fullNameKey = 'full_name';
const emailKey = 'email';
