import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/views/statistics_view.dart';

abstract class DatabaseProvider {
  void init();
}

abstract class DatabaseGamesProvider extends DatabaseProvider {
  Future<Iterable<DatabaseGame>> getAllGames();
  void searchGame(String names);
  void applyFilters(Filters filters);
}
