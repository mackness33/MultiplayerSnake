import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_games_service.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/services/database/database_profiles_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final DatabaseProfilesService _databaseService = DatabaseProfilesService();
  late final TextEditingController _website;
  late final TextEditingController _fullName;
  late final TextEditingController _avatarUrl;
  late bool _editWebsite;
  late bool _editFullName;
  late bool _editAvatarUrl;
  late List<Widget> informationsListTiles;

  @override
  void initState() {
    _databaseService.init();
    _website = TextEditingController();
    _fullName = TextEditingController();
    // _avatarUrl = TextEditingController(
    //     text:
    //         'https://vignette.wikia.nocookie.net/legogames/images/4/45/Batman_(Classic)_icon.png/revision/latest?cb=20180313231636');
    _avatarUrl = TextEditingController();
    _editWebsite = true;
    _editFullName = true;
    _editAvatarUrl = true;
    super.initState();
  }

  @override
  void dispose() {
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
          child: StreamBuilder(
              stream: _databaseService.profile,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData && snapshot.data?.id != null) {
                      final profile = snapshot.data as DatabaseProfile;
                      _avatarUrl.text = profile.avatarUrl ?? '';
                      _website.text = profile.website ?? '';
                      _fullName.text = profile.fullName ?? '';
                      return Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white70,
                                          minRadius: 60.0,
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage:
                                                (_avatarUrl.text != '')
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
                                                _editAvatarUrl =
                                                    !_editAvatarUrl;
                                                if (_editAvatarUrl) {
                                                  _databaseService
                                                      .updateProfile(
                                                          key: avatarUrlKey,
                                                          value:
                                                              _avatarUrl.text);
                                                }
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
                                  subtitle: Text(
                                    profile.email ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  )),
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
                                        if (_editWebsite) {
                                          _databaseService.updateProfile(
                                              key: websiteKey,
                                              value: _website.text);
                                        }
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
                                        if (_editFullName) {
                                          _databaseService.updateProfile(
                                              key: fullNameKey,
                                              value: _fullName.text);
                                        }
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
