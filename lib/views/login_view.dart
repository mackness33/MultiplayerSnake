import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter email")),
          const SizedBox(height: 10),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter password"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String email = _email.text;
              String password = _password.text;

              final supabase = Supabase.instance.client;
              try {
                await supabase.auth
                    .signInWithPassword(email: email, password: password);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/menu/', (_) => false);
              } on AuthException catch (e) {
                context.showErrorSnackBar(message: e.message);
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signup/', (_) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
