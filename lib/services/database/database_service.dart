// import 'dart:async';

// import 'package:multiplayersnake/services/auth/auth_service.dart';
// import 'package:multiplayersnake/services/database/database_entity.dart';
// import 'package:multiplayersnake/services/database/database_game.dart';
// import 'package:multiplayersnake/services/database/database_provider.dart';
// import 'package:multiplayersnake/services/game/game_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'database_exceptions.dart';
// import 'dart:developer' as devtools show log;

// class DatabaseService<T extends DatabaseEntity> implements DatabaseProvider {
//   final SupabaseClient supabase;
//   final String user;
//   final String? table;

//   List<T> _entities = [];

//   // static final DatabaseService _shared = DatabaseService._sharedInstance(user: user);
//   // DatabaseService._sharedInstance() : supabase = Supabase.instance.client, user = AuthService.supabase().currentUser!.email;

//   // factory DatabaseService() => _shared;

//   final _entitiesStreamController =
//       StreamController<List<T>>.broadcast();

//   Future<void> _cacheGames() async {
//     final allEntities = await getAllEntities(table: '');
//     _entities = allEntities.toList();
//     _entitiesStreamController.add(_entities);
//   }

//   DatabaseService({required this.user, this.table})
//       : supabase = Supabase.instance.client;

//   @override
//   void init() async {
//     await _cacheGames();
//   }

//   @override
//   Future<Iterable<T>> getAllEntities({required String table}) async {
//     try {
//       if (table == null) {
//         throw NoBasicTableException;
//       }

//       final List<Map<String, dynamic>> entities =
//           await supabase.from(table).select('*');
//       devtools.log(entities.toString());

//       return entities.map((gameRow) => T.fromRow(gameRow));
//     } on DatabaseException catch (_) {
//       throw GenericDatabaseException();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
