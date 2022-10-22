import "package:flutter/material.dart";
import 'package:multiplayersnake/utils/constants.dart';
import 'dart:developer' as devtools show log;

import 'package:supabase_flutter/supabase_flutter.dart';

enum MenuAction { logout }

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      try {
                        await Supabase.instance.client.auth.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/login/', (_) => false);
                      } on AuthException catch (e) {
                        context.showErrorSnackBar(message: e.message);

                        if (Supabase.instance.client.auth.currentUser == null) {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/login/', (_) => false);
                        }
                      }
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            )
          ],
        ),
        body: const Center(
          child: Text("The user is logged!"),
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure youwant to log out?'),
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
