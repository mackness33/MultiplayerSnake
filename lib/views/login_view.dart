import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/auth/auth_exceptions.dart';
import 'package:multiplayersnake/services/auth/auth_service.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';

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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthStateLoggedOut) {
                if (state.exception is InvalidCredentialsException) {
                  context.showErrorSnackBar(
                      message: 'Invalid login credentials!');
                } else if (state.exception is UserNotVerifiedException) {
                  context.showErrorSnackBar(
                      message: 'User is not verified. Check the email!');
                } else if (state.exception is GenericAuthException) {
                  context.showErrorSnackBar(message: 'Authentication error');
                }
              }
            },
            child: ElevatedButton(
              onPressed: () async {
                String email = _email.text;
                String password = _password.text;

                context.read<AuthBloc>().add(AuthEventLogin(email, password));
              },
              child: const Text("Login"),
            ),
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
