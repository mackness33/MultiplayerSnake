import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:multiplayersnake/game/components/body_component.dart';
import 'package:multiplayersnake/game/views/play_view.dart';
import 'package:multiplayersnake/services/game/game_provider.dart';

class MultiplayerSnakeGame extends FlameGame
    with HasTappableComponents, SingleGameInstance, GameProvider {
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    print('IsLoading');
    add(
      router = RouterComponent(
        routes: {
          // 'splash-screen': Route(SplashScreenView.new),
          'play': Route(PlayView.new),
          // 'resume': Route(ResumeView.new),
          // 'level-selector': Route(LevelSelectorPage.new),
          // 'settings': Route(SettingsPage.new, transparent: true),
          // 'confirm-dialog': OverlayRoute.existing(),
        },
        initialRoute: 'play',
      ),
    );
    print('IsLoaded');
  }

  @override
  void onRemove() {
    print('IsRemoving');
    super.onRemove();
    _endedCompleter.complete();
    print('IsRemoved');
  }

  @override
  void onDetach() {
    _endingCompleter.complete();
    print('isDetaching');
    super.onDetach();
    print('IsDetached');
  }

  @override
  void onAttach() {
    print('IsAttaching');
    super.onAttach();
    print('IsAttached');
  }

  @override
  void onMount() {
    print('IsMounting');
    super.onMount();
    print('IsMounted');
  }

  // endend
  final Completer<void> _endedCompleter = Completer();
  @override
  Future<void> get ended => _endedCompleter.future;

  // ending
  final Completer<void> _endingCompleter = Completer();
  @override
  Future<void> get ending => _endingCompleter.future;
}
