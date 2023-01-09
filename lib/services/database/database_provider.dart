import 'package:multiplayersnake/services/database/database_game.dart';

abstract class DatabaseProvider {
  void init();
}

abstract class DatabaseGamesProvider extends DatabaseProvider {
  Future<Iterable<DatabaseGame>> getAllGames();

  Future<Iterable<DatabaseGame>> getGames(List<String> names);

  Future<DatabaseGame> getGame(int id);
}
