import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';
import 'package:multiplayersnake/views/statistics_view.dart';

abstract class DatabaseProvider {
  void init();
}

abstract class DatabaseGamesProvider extends DatabaseProvider {
  Future<Iterable<DatabaseGame>> getAllGames();
  void searchGame(String names);
  void applyFilters(Filters filters);
  void onlyWinsFilter(bool? onlyWins);
}

abstract class DatabaseProfilesProvider extends DatabaseProvider {
  Future<DatabaseProfile> getProfile({String? email});
  Future<void> updateProfile({required String key, required dynamic value});
}
