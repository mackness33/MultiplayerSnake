import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/auth/supabase_auth_provider.dart';
import 'package:multiplayersnake/services/game/game_rules.dart';
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
    _gameRules = GameRules(SupabaseAuthProvider().currentUser!.email);
    _room = TextEditingController();
    super.initState();
  }

  Widget createForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchWidget(
          trailing: publicSwitch(isPublic: _gameRules.public, title: 'Public'),
          title: 'Create',
          isAdmin: false,
        ),
        option(
          title: 'Players',
          setNewIndex: setPlayers,
          selectedOption: _gameRules.indexPlayers,
          possibleOptions: _gameRules.valuePlayers,
        ),
        option(
          title: 'Time',
          setNewIndex: setTime,
          selectedOption: _gameRules.indexTime,
          possibleOptions: _gameRules.valueTime,
        ),
        option(
          title: 'Points',
          setNewIndex: setPoints,
          selectedOption: _gameRules.indexPoints,
          possibleOptions: _gameRules.valuePoints,
        ),
      ],
    );
  }

  Widget publicSwitch({
    required bool isPublic,
    required String title,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17.5),
        ),
        const SizedBox(width: 10),
        Switch(
          value: isPublic,
          onChanged: (bool value) {
            setPublic(value: value);
          },
        ),
      ],
    );
  }

  void setPublic({required bool value}) {
    setState(() {
      _gameRules.public = value;
    });
  }

  void setPoints({required int value}) {
    setState(() {
      _gameRules.indexPoints = value;
    });
  }

  void setTime({required int value}) {
    setState(() {
      _gameRules.indexTime = value;
    });
  }

  void setPlayers({required int value}) {
    setState(() {
      _gameRules.indexPlayers = value;
    });
  }

  Widget option({
    required Function setNewIndex,
    required int selectedOption,
    required List<int> possibleOptions,
    required String title,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(
                possibleOptions.length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color:
                          selectedOption == index ? Colors.white : Colors.blue,
                    ),
                    child: InkWell(
                      enableFeedback: false,
                      onTap: () {
                        setNewIndex(value: index);
                      },
                      child: Center(
                        child: Text(
                          possibleOptions[index].toString(),
                          style: TextStyle(
                            color: (selectedOption == index)
                                ? Colors.red
                                : Colors.amber,
                            fontSize: 17.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget joinForm() {
    return searchWidget(title: 'Join', isAdmin: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Center(child: Text('Loading')),
        actions: [
          IconButton(
              onPressed: () {
                context.read<GameBloc>().add(const GameEventLeft());
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                actionButtons(title: 'Create', isCreating: true),
                actionButtons(title: 'Join', isCreating: false),
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

  Widget actionButtons({required String title, required bool isCreating}) {
    return Container(
      height: 75,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            create = isCreating;
          });
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget searchWidget(
      {Widget? trailing, required String title, required bool isAdmin}) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (trailing != null) trailing,
          Expanded(
            child: TextField(
              controller: _room,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(fontSize: 17.5),
              decoration: const InputDecoration(
                labelText: 'Room',
                hintText: "Enter room",
                border: OutlineInputBorder(),
              ),
              onChanged: (String room) {
                setState(() {
                  _gameRules.room = room;
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _gameRules.isAdmin = isAdmin;
              context.read<GameBloc>().add(
                    GameEventConfigured(
                      SettingsService.screenSize(MediaQuery.of(context)),
                      _gameRules,
                      create!,
                    ),
                  );
            },
            child: Text(
              title,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }
}
