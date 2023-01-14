import 'package:multiplayersnake/services/database/database_friend.dart';
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_profile.dart';
import 'package:multiplayersnake/views/information_views/statistics_view.dart';

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
  Future<DatabaseProfile> getProfile({String? id});
  Future<void> updateProfile({required String key, required dynamic value});
}

abstract class DatabaseFriendsProvider extends DatabaseProvider {
  Future<Iterable<DatabaseFriend>> getAllFriends();
  Future<void> addFriend({required String id});
  Future<void> deleteFriend({required String id});
  Future<void> acceptFriend({required String id});
  Future<void> searchPlayer(String player);
}
