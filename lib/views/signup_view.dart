import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        body: FutureBuilder(
          future: Supabase.initialize(
            url: dotenv.get('SUPABASE_URL'),
            anonKey: dotenv.get('SUPABASE_ANNON_KEY'),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(hintText: "Enter email")),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration:
                          const InputDecoration(hintText: "Enter password"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _email.text;
                        String password = _password.text;

                        final supabase = Supabase.instance.client;
                        try {
                          final AuthResponse userCred = await supabase.auth
                              .signUp(email: email, password: password);

                          print(userCred.session);
                        } on AuthException catch (e) {
                          context.showErrorSnackBar(message: e.message);
                          print(e);
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ],
                );
              default:
                return const Text("Loding..");
            }
          },
        ));
  }
}
