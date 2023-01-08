import 'package:multiplayersnake/services/database/database_game.dart';

abstract class DatabaseProvider {
  Future<Iterable<DatabaseGame>> getAllGames();

  Future<Iterable<DatabaseGame>> getGames(List<String> names);

  Future<DatabaseGame> getGame(int id);
}
