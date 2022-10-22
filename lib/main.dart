import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multiplayersnake/utils/constants.dart';
import 'package:multiplayersnake/views/login_view.dart';
import 'package:multiplayersnake/views/menu_view.dart';
import 'package:multiplayersnake/views/signup_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        home: const HomePage(),
        routes: {
          '/login/': (context) => const LoginView(),
          '/signup/': (context) => const SignupView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Supabase.initialize(
        url: dotenv.get('SUPABASE_URL'),
        anonKey: dotenv.get('SUPABASE_ANNON_KEY'),
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final session = SupabaseAuth.instance.initialSession;
            // final emailVerified = session;
            return FutureBuilder(
              future: SupabaseAuth.instance.initialSession,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    // final session = SupabaseAuth.instance.initialSession;
                    // final emailVerified = session;
                    final session = snapshot.data;
                    if (session?.user == null) {
                      return const LoginView();
                    } else {
                      if (session?.user.emailConfirmedAt != null) {
                        return const MenuView();
                      } else {
                        context.showErrorSnackBar(
                            message:
                                'You\'re not a verified user! Check your email');
                        return const LoginView();
                      }
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
