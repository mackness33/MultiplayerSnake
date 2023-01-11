import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_friends_service.dart';
import 'package:multiplayersnake/services/database/database_games_service.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/services/database/database_profiles_service.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final DatabaseFriendsService _databaseService = DatabaseFriendsService();

  @override
  void initState() {
    _databaseService.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _databaseService.allFriends,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final friends = snapshot.data as List<DatabaseFriend>;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: friends.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            title: Text(
                              ((friends[index].amRequester)
                                      ? friends[index].requesterEmail
                                      : friends[index].followedEmail) ??
                                  'Not Found',
                            ),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (!friends[index].isConfirmed)
                                  IconButton(
                                    onPressed: () {
                                      devtools.log('Accepted!');
                                    },
                                    icon: const Icon(Icons.check_circle),
                                  ),
                                IconButton(
                                  onPressed: () {
                                    devtools.log('Deleted!');
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
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
        ),
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
