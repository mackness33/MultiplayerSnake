import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_bloc.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_event.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_state.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  bool? create;
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: Column(
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
          const Text("Max players: "),
          const SizedBox(height: 30),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(3, (index) {
              print("selectedIndex: $selectedIndex");
              print("index: $index");
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
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
                    color: selectedIndex == index ? Colors.white : Colors.blue,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            color: (selectedIndex == index)
                                ? Colors.red
                                : Colors.amber),
                      ),
                    ),
                  ),
                ),
              );
            }),
          )

          // ElevatedButton(
          //   onPressed: () {
          //     context.read<GameBloc>().add(
          //           GameEventCreated(
          //             SettingsService.screenSize(MediaQuery.of(context)),
          //           ),
          //         );
          //   },
          //   child: const Text('Start'),
          // ),
        ],
      ),
    );
  }
}
