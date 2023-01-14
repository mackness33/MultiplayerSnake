import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplayersnake/services/auth/auth_exceptions.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';
import 'package:multiplayersnake/utils/constants.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseException) {
            context.showErrorSnackBar(
                message: 'This email has already been used.');
          } else if (state.exception is InvalidEmailFormatException) {
            context.showErrorSnackBar(message: 'Invalid email format');
          } else if (state.exception is WeakPasswordException) {
            context.showErrorSnackBar(
                message:
                    'The password is too weak. The length must be at least of 6 characters');
          } else if (state.exception is GenericAuthException) {
            context.showErrorSnackBar(message: 'Failed to Register');
          } else {
            showVerifyEmailDialog(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Signup"))),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 17.5),
                      decoration: const InputDecoration(
                        hintText: "Enter email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 17.5),
                      decoration: const InputDecoration(
                        hintText: "Enter password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 100,
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          String email = _email.text;
                          String password = _password.text;

                          context
                              .read<AuthBloc>()
                              .add(AuthEventSignup(email, password));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 17.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text(
                  'Alredy registered? Login here!',
                  style: TextStyle(fontSize: 17.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
