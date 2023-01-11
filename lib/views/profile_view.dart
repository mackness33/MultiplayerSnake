import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_games_service.dart';

import "dart:developer" as devtools show log;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // final DatabaseProfilesService _databaseService = DatabaseProfilesService();
  late final TextEditingController _email;
  late final TextEditingController _website;
  late final TextEditingController _fullName;
  late final TextEditingController _avatarUrl;
  late bool _editEmail;
  late bool _editWebsite;
  late bool _editFullName;
  late bool _editAvatarUrl;
  late List<Widget> informationsListTiles;

  @override
  void initState() {
    // _databaseService.init();
    _email = TextEditingController(text: 'palmeiro.leonardo@gmail.com');
    _website = TextEditingController(text: 'https://github.com/leopalmeiro');
    _fullName = TextEditingController(
        text: 'www.linkedin.com/in/leonardo-palmeiro-834a1755');
    _avatarUrl = TextEditingController(
        text:
            'https://vignette.wikia.nocookie.net/legogames/images/4/45/Batman_(Classic)_icon.png/revision/latest?cb=20180313231636');
    _editEmail = true;
    _editWebsite = true;
    _editFullName = true;
    _editAvatarUrl = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _website.dispose();
    _fullName.dispose();
    _avatarUrl.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              minRadius: 60.0,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: (_avatarUrl.text != '')
                                    ? NetworkImage(
                                        _avatarUrl.text,
                                      )
                                    : const NetworkImage(
                                        'https://www.shareicon.net/data/512x512/2016/09/01/822742_user_512x512.png',
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: (() => setState(() {
                                    _editAvatarUrl = !_editAvatarUrl;
                                  })),
                              icon: (_editAvatarUrl)
                                  ? const Icon(Icons.edit)
                                  : const Icon(Icons.save),
                            ),
                          ],
                        ),
                        if (!_editAvatarUrl)
                          TextField(
                              controller: _avatarUrl,
                              style: const TextStyle(
                                fontSize: 18,
                              )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: (_editEmail)
                        ? Text(
                            _email.text,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          )
                        : TextField(
                            controller: _email,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                    trailing: IconButton(
                      onPressed: (() => setState(() {
                            _editEmail = !_editEmail;
                          })),
                      icon: (_editEmail)
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.save),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Website',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: (_editWebsite)
                        ? Text(
                            _website.text,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          )
                        : TextField(
                            controller: _website,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                    trailing: IconButton(
                      onPressed: (() => setState(() {
                            _editWebsite = !_editWebsite;
                          })),
                      icon: (_editWebsite)
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.save),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Full Name',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: (_editFullName)
                        ? Text(
                            _fullName.text,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          )
                        : TextField(
                            controller: _fullName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                    trailing: IconButton(
                      onPressed: (() => setState(() {
                            _editFullName = !_editFullName;
                          })),
                      icon: (_editFullName)
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.save),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ],
              )
            ],
          ),
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
