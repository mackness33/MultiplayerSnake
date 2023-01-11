import "dart:developer" as devtools show log;

import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_friends_service.dart';
import 'package:multiplayersnake/views/add_friend_view.dart';
import 'package:multiplayersnake/views/static_profile_view.dart';

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
        title: const Text("Friends"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFriendsView()),
                );
              },
              icon: const Icon(Icons.add))
        ],
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
                          final String idFriend = (friends[index].amRequester)
                              ? friends[index].followed
                              : friends[index].requester;
                          return ListTile(
                            title: Text(
                              ((friends[index].amRequester)
                                      ? friends[index].followedEmail
                                      : friends[index].requesterEmail) ??
                                  'Not Found',
                            ),
                            subtitle: (friends[index].isConfirmed)
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.all(3.0),
                                    padding: const EdgeInsets.all(3.0),
                                    constraints: const BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: (friends[index].amRequester)
                                              ? Colors.blue.shade900
                                              : Colors.amber.shade400,
                                          width: 3),
                                      color: (friends[index].amRequester)
                                          ? const Color.fromARGB(
                                              158, 33, 149, 243)
                                          : const Color.fromARGB(
                                              160, 249, 200, 56),
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(40, 40)),
                                    ),
                                    child: (friends[index].amRequester)
                                        ? const Center(child: Text('Requested'))
                                        : const Center(child: Text('Pending')),
                                  ),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (!friends[index].amRequester &&
                                    !friends[index].isConfirmed)
                                  IconButton(
                                    onPressed: () {
                                      devtools.log('Accepted!');
                                      _databaseService.acceptFriend(
                                          id: idFriend);
                                    },
                                    icon: const Icon(Icons.check_circle),
                                  ),
                                IconButton(
                                  onPressed: () {
                                    devtools.log('Deleted!');
                                    _databaseService.deleteFriend(id: idFriend);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StaticProfileView(
                                                  profileId: idFriend)),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
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
