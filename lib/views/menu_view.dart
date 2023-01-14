import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/enums/menu_action.dart';
import 'package:multiplayersnake/services/auth/auth_exceptions.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/game/blocs/game_bloc.dart';
import 'package:multiplayersnake/services/game/blocs/game_event.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/friends_view.dart';
import 'package:multiplayersnake/views/profile_view.dart';
import 'package:multiplayersnake/views/static_profile_view.dart';
import 'package:multiplayersnake/views/statistics_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  void logout() async {
    try {
      context.read<AuthBloc>().add(const AuthEventLogout());
    } on UserNotLoggedInException {
      context.showErrorSnackBar(message: 'The user is not logged in');

      if (Supabase.instance.client.auth.currentUser == null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
      }
    } on GenericAuthException {
      context.showErrorSnackBar(message: 'Authentication Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Menu")),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) logout();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            option(
                onPressed: addEvent(event: const GameEventConnection()),
                title: 'Play'),
            option(
                onPressed: navigateTo(const StatisticsView()), title: 'Stats'),
            option(
                onPressed: navigateTo(const ProfileView()), title: 'Profile'),
            option(
                onPressed: navigateTo(const FriendsView()), title: 'Friends'),
          ],
        ),
      ),
    );
  }

  void Function() navigateTo(StatefulWidget view) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => view),
      );
    };
  }

  void Function() addEvent({required GameEvent event}) {
    return () {
      context.read<GameBloc>().add(event);
    };
  }

  Widget option({required void Function() onPressed, required String title}) {
    return Container(
      height: 75,
      width: 150,
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
