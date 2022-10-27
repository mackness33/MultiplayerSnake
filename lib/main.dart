import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_bloc.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';
import 'package:multiplayersnake/services/auth/supabase_auth_provider.dart';
import 'package:multiplayersnake/views/game_view.dart';
import 'package:multiplayersnake/views/login_view.dart';
import 'package:multiplayersnake/views/menu_view.dart';
import 'package:multiplayersnake/views/signup_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(SupabaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        '/game/': (context) => const GamePage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MenuView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const SignupView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
