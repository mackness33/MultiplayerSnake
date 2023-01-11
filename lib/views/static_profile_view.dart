import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_games_service.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/services/database/database_profiles_service.dart';

class StaticProfileView extends StatefulWidget {
  final String profileEmail;
  const StaticProfileView({
    super.key,
    required this.profileEmail,
  });

  @override
  State<StaticProfileView> createState() => _StaticProfileViewState();
}

class _StaticProfileViewState extends State<StaticProfileView> {
  final DatabaseProfilesService _databaseService = DatabaseProfilesService();

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
          child: FutureBuilder(
              future: _databaseService.getProfile(email: widget.profileEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData && snapshot.data?.id != null) {
                      final DatabaseProfile profile =
                          snapshot.data as DatabaseProfile;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(30),
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                minRadius: 60.0,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: (profile.avatarUrl != null &&
                                          profile.avatarUrl != '')
                                      ? NetworkImage(
                                          profile.avatarUrl!,
                                        )
                                      : const NetworkImage(
                                          'https://www.shareicon.net/data/512x512/2016/09/01/822742_user_512x512.png',
                                        ),
                                ),
                              ),
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
                              if (profile.website != null)
                                ListTile(
                                    title: Text(
                                      'Website',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      profile.website!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )),
                              const Divider(
                                height: 1,
                                thickness: 1,
                              ),
                              if (profile.fullName != null)
                                ListTile(
                                    title: Text(
                                      'Full Name',
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      profile.fullName!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )),
                              const Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          )
                        ],
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

const avatarUrlKey = 'avatar_url';
const websiteKey = 'website';
const fullNameKey = 'full_name';
const emailKey = 'email';
