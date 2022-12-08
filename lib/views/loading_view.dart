import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final GameSettings _gameSetting;
  late final TextEditingController _name;

  @override
  void initState() {
    _gameSetting = GameSettings();
    _name = TextEditingController();
    super.initState();
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
                      create = true;
                      print(create);
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
                      create = false;
                      print(create);
                    },
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                  _gameSetting.name = name;
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
                        _gameSetting.indexPlayers = index;
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
                        color: _gameSetting.indexPlayers == index
                            ? Colors.white
                            : Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              color: (_gameSetting.indexPlayers == index)
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
                        _gameSetting.indexTime = index;
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
                        color: _gameSetting.indexTime == index
                            ? Colors.white
                            : Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              color: (_gameSetting.indexTime == index)
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
                        _gameSetting.indexPoints = index;
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
                        color: _gameSetting.indexPoints == index
                            ? Colors.white
                            : Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              color: (_gameSetting.indexPoints == index)
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
                  value: _gameSetting.public,
                  onChanged: (bool newValue) {
                    setState(() {
                      _gameSetting.public = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(
                      GameEventCreated(
                        SettingsService.screenSize(MediaQuery.of(context)),
                      ),
                    );
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameSettings {
  int indexPlayers;
  int indexTime;
  int indexPoints;
  String name;
  bool public;
  final List<int> players = [1, 2, 3];
  final List<int> time = [1, 2, 5];
  final List<int> points = [100, 200, 400, 1000];

  GameSettings()
      : indexPlayers = 0,
        indexTime = 0,
        indexPoints = 0,
        name = '',
        public = false;

  int get maxPlayers => players[indexPlayers];
  int get maxTime => time[indexTime];
  int get maxPoints => points[indexPoints];
}
