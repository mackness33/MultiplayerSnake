import 'package:flutter/material.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as devtools show log;

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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
      appBar: AppBar(title: const Text("Signup")),
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
                final response = await supabase.auth
                    .signUp(email: email, password: password);

                final confirmationSentAt =
                    response.user?.confirmationSentAt?.split('.')[0];
                final createdAt = response.user?.createdAt.split('.')[0];
                return (confirmationSentAt == createdAt)
                    ? showVerifyEmailDialog(context)
                    : context.showErrorSnackBar(
                        message: 'This email has already been used.');
              } on AuthException catch (e) {
                context.showErrorSnackBar(message: e.message);
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (_) => false);
            },
            child: const Text('Alredy registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
