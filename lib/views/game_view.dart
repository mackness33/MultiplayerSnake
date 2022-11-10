import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/game/game.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/services/game/game_service.dart';
import 'package:multiplayersnake/services/settings/settings_service.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final GameService _game;

  @override
  void initState() {
    _game = GameService.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<GameBloc>().add(const GameEventPlay());
    final screen = SettingsService.screenSize(MediaQuery.of(context));
    _game.newGame(screen);
    return GameWidget(game: _game.getGame);
  }
}
