// import 'package:flutter/material.dart';
// import 'package:multiplayersnake/game/game.dart';
// import 'package:multiplayersnake/services/game/game_provider.dart';
// import 'package:multiplayersnake/services/settings/settings_service.dart';

// class GameService implements GameProvider {
//   late MultiplayerSnakeGame _game;
//   GameService(this._game);
//   GameService.empty() {
//     this._game = MultiplayerSnakeGame.empty();
//   }

//   factory GameService.snake(Rect screen) =>
//       GameService(MultiplayerSnakeGame(screen));

//   void newGame(Rect screen) {
//     if (_game.isLoaded) {
//       _game.onRemove();
//     }
//     _game = MultiplayerSnakeGame(screen);
//   }

//   MultiplayerSnakeGame get getGame => _game;

//   @override
//   Future<void> get loaded => _game.loaded;
//   @override
//   Future<void> get mounted => _game.mounted;
//   @override
//   Future<void> get ended => _game.ended;
//   @override
//   Future<void> get ending => _game.ending;
// }
