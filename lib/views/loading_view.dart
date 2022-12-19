import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/models/game_rules.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  bool? create;
  late final GameRules _gameRules;
  late final TextEditingController _room;

  @override
  void initState() {
    String email =
        (context.read<AuthBloc>().state as AuthStateLoggedIn).user.email;
    _gameRules = GameRules(email);
    _room = TextEditingController();
    super.initState();
  }

  Widget createForm() {
    return Column(
      children: [
        const Text("Room: "),
        const SizedBox(height: 10),
        TextField(
          controller: _room,
          obscureText: false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter room"),
          onChanged: (String room) {
            setState(() {
              _gameRules.room = room;
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
                    _gameRules.indexPlayers = index;
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
                    color: _gameRules.indexPlayers == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameRules.indexPlayers == index)
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
                    _gameRules.indexTime = index;
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
                    color: _gameRules.indexTime == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameRules.indexTime == index)
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
                    _gameRules.indexPoints = index;
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
                    color: _gameRules.indexPoints == index
                        ? Colors.white
                        : Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: (_gameRules.indexPoints == index)
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
              value: _gameRules.public,
              onChanged: (bool newValue) {
                setState(() {
                  _gameRules.public = newValue;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            _gameRules.isAdmin = true;
            print("create: $create");
            context.read<GameBloc>().add(
                  GameEventConfigured(
                    SettingsService.screenSize(MediaQuery.of(context)),
                    _gameRules,
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
        const Text("Room: "),
        const SizedBox(height: 10),
        TextField(
          controller: _room,
          obscureText: false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter room"),
          onChanged: (String room) {
            setState(() {
              _gameRules.room = room;
            });
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            _gameRules.isAdmin = false;
            context.read<GameBloc>().add(
                  GameEventConfigured(
                    SettingsService.screenSize(MediaQuery.of(context)),
                    _gameRules,
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
