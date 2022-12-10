import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/models/game_settings.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';
import 'package:supabase/supabase.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  bool? create;
  late final GameSettings _gameSettings;
  late final TextEditingController _name;

  @override
  void initState() {
    String email =
        (context.read<AuthBloc>().state as AuthStateLoggedIn).user.email;
    _gameSettings = GameSettings();
    _gameSettings.addPlayer(email);
    _name = TextEditingController();
    super.initState();
  }

  void setName(String newState) {
    setState(() {
      _gameSettings.name = newState;
    });
  }

  void setIndexPlayers(int newState) {
    setState(() {
      _gameSettings.indexPlayers = newState;
    });
  }

  void setIndexTime(int newState) {
    setState(() {
      _gameSettings.indexTime = newState;
    });
  }

  void setIndexPoints(int newState) {
    setState(() {
      _gameSettings.indexPoints = newState;
    });
  }

  void setPublic(bool newState) {
    setState(() {
      _gameSettings.public = newState;
    });
  }

  Widget createForm() {
    return Column(
      children: [
        const Text("Name: "),
        const SizedBox(height: 10),
        TextField(
          controller: _name,
          obscureText: false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter name"),
          onChanged: (String name) {
            setState(() {
              _gameSettings.name = name;
            });
          },
        ),
        const SizedBox(height: 30),
        const Text("Max players: "),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _gameSettings.indexPlayers = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _gameSettings.indexPlayers == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameSettings.indexPlayers == index)
                              ? Colors.red
                              : Colors.amber),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        const Text("Max time: "),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _gameSettings.indexTime = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _gameSettings.indexTime == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameSettings.indexTime == index)
                              ? Colors.red
                              : Colors.amber),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        const Text("Max points: "),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _gameSettings.indexPoints = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _gameSettings.indexPoints == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameSettings.indexPoints == index)
                              ? Colors.red
                              : Colors.amber),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Text("Public: "),
            const SizedBox(width: 10),
            Switch(
              value: _gameSettings.public,
              onChanged: (bool newValue) {
                setState(() {
                  _gameSettings.public = newValue;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            context.read<GameBloc>().add(
                  GameEventConfigured(
                    SettingsService.screenSize(MediaQuery.of(context)),
                    _gameSettings,
                    create!,
                  ),
                );
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  Widget joinForm() {
    return Column(
      children: [
        const Text("Name: "),
        const SizedBox(height: 10),
        TextField(
          controller: _name,
          obscureText: false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter name"),
          onChanged: (String name) {
            setState(() {
              _gameSettings.name = name;
            });
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            context.read<GameBloc>().add(
                  GameEventConfigured(
                    SettingsService.screenSize(MediaQuery.of(context)),
                    _gameSettings,
                    create!,
                  ),
                );
          },
          child: const Text('Join'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Loading')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 75,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        create = true;
                      });
                    },
                    child: const Text('Create'),
                  ),
                ),
                Container(
                  height: 75,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        create = false;
                      });
                    },
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Builder(
              builder: ((context) {
                return Container(
                  child: create == null
                      ? null
                      : create!
                          ? createForm()
                          : joinForm(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
