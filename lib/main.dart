import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multiplayersnake/services/auth/auth_service.dart';
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
        home: const HomePage(),
        routes: {
          '/login/': (context) => const LoginView(),
          '/signup/': (context) => const SignupView(),
          '/menu/': (context) => const MenuView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.supabase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return FutureBuilder(
              future: AuthService.supabase().initialSession,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final session = snapshot.data;

                    return (session?.user != null)
                        ? const MenuView()
                        : const LoginView();
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
