import 'dart:math';
import 'dart:developer' as devtools show log;

import 'package:flutter/foundation.dart';

@immutable
class DatabaseGame {
  final int id;
  final String name;
  final DateTime createdAt;
  final int maxTime;
  final int maxPoints;
  final bool public;
  late final List<DatabasePlayer> players;
  late final int _indexUser;

  DatabaseGame.fromJSON(Map<String, dynamic> json, String userEmail)
      : id = json[idColumn] as int,
        name = json[nameColumn] as String,
        createdAt = DateTime.now(),
        maxTime = json[maxTimeColumn] as int,
        public = json[publicColumn] as bool,
        maxPoints = json[maxPointsColumn] as int {
    _populatePlayers(playersInfo: json, user: userEmail);
  }
  DatabaseGame.fromRow(Map<String, dynamic> row, String userEmail)
      : id = row[idColumn] as int,
        name = row[nameColumn] as String,
        createdAt = DateTime.tryParse(row[createdAtColumn])?.toUtc() ??
            DateTime.now().toUtc(),
        maxTime = row[maxTimeColumn] as int,
        public = row[publicColumn] ?? false,
        maxPoints = row[maxTimeColumn] as int {
    _populatePlayers(playersInfo: row, user: userEmail);
  }

  DatabasePlayer get user => players[_indexUser];

  void _populatePlayers({
    required Map<String, dynamic> playersInfo,
    required String user,
  }) {
    int index = 0;
    int maxPointsMade = playersInfo[firstPlayerPointsColumn];
    players = <DatabasePlayer>[
      DatabasePlayer(playersInfo[firstPlayerPointsColumn] as int,
          playersInfo[firstPlayerColumn][emailColumn] as String, false)
    ];
    if (playersInfo[secondPlayerColumn]?[emailColumn] != null) {
      index = (!user.contains(playersInfo[secondPlayerColumn][emailColumn]))
          ? index
          : 1;
      maxPointsMade =
          max(maxPointsMade, playersInfo[secondPlayerPointsColumn] ?? 0);
      players.add(DatabasePlayer(playersInfo[secondPlayerPointsColumn] ?? 0,
          playersInfo[secondPlayerColumn][emailColumn] as String, false));
    }
    if (playersInfo[thirdPlayerColumn]?[emailColumn] != null) {
      index = (!user.contains(playersInfo[thirdPlayerColumn][emailColumn]))
          ? index
          : 2;
      maxPointsMade =
          max(maxPointsMade, playersInfo[thirdPlayerPointsColumn] ?? 0);
      players.add(DatabasePlayer(playersInfo[thirdPlayerPointsColumn] ?? 0,
          playersInfo[thirdPlayerColumn][emailColumn] as String, false));
    }
    if (playersInfo[fourthPlayerColumn]?[emailColumn] != null) {
      index = (!user.contains(playersInfo[fourthPlayerColumn][emailColumn]))
          ? index
          : 3;
      maxPointsMade =
          max(maxPointsMade, playersInfo[secondPlayerPointsColumn] ?? 0);
      players.add(DatabasePlayer(playersInfo[fourthPlayerPointsColumn] ?? 0,
          playersInfo[fourthPlayerColumn][emailColumn] as String, false));
    }

    _indexUser = index;

    for (var player in players) {
      player.isWinner = player.points == maxPointsMade;
    }
  }

  int get index => _indexUser;

  @override
  String toString() =>
      'Game, ID = $id, name = $name, player = ${players[_indexUser]}, createdAt = $createdAt';

  @override
  bool operator ==(covariant DatabaseGame other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabasePlayer {
  final int points;
  final String email;
  bool isWinner;

  DatabasePlayer(this.points, this.email, this.isWinner);

  @override
  String toString() =>
      'Player, email = $email, points = $points, isWinner = $isWinner';
}

const gameTable = 'games';
const idColumn = 'id';
const nameColumn = 'name';
const createdAtColumn = 'created_at';
const emailColumn = 'email';
const maxTimeColumn = 'max_time';
const maxPointsColumn = 'max_points';
const publicColumn = 'public';
const firstPlayerColumn = 'player0';
const firstPlayerPointsColumn = 'player0_points';
const secondPlayerColumn = 'player1';
const secondPlayerPointsColumn = 'player1_points';
const thirdPlayerColumn = 'player2';
const thirdPlayerPointsColumn = 'player2_points';
const fourthPlayerColumn = 'player3';
const fourthPlayerPointsColumn = 'player3_points';
