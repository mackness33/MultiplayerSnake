import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:multiplayersnake/game/views/play_view.dart';
import 'package:multiplayersnake/game/views/resume_view.dart';
import 'package:multiplayersnake/game/views/splashscreen_view.dart';

class MultiplayerSnakeGame extends FlameGame
    with HasTappableComponents, SingleGameInstance {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'splash-screen': Route(SplashScreenView.new),
          'play': Route(PlayView.new),
          'resume': Route(ResumeView.new),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'splash-screen',
      ),
    );
  }
}
