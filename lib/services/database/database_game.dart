import 'package:flutter/foundation.dart';

@immutable
class DatabaseGame {
  final int id;
  final String name;
  final DateTime createdAt;
  final int maxTime;
  final String player0;
  final int points0;
  final String player1;
  final int points1;
  final String player2;
  final int points2;
  final String player3;
  final int points3;
  final String user;
  late final int pointsUser;
  late final bool winner;

  DatabaseGame.fromJSON(Map<String, dynamic> json, String userEmail)
      : id = json[idColumn] as int,
        name = json[nameColumn] as String,
        createdAt = DateTime.now(),
        maxTime = json[maxTimeColumn] as int,
        player0 = json[firstPlayerColumn][emailColumn] as String,
        points0 = json[firstPlayerPointsColumn] as int,
        player1 = json[secondPlayerColumn]?[emailColumn] ?? 'player 2',
        points1 = json[secondPlayerPointsColumn] ?? 0,
        player2 = json[thirdPlayerColumn]?[emailColumn] ?? 'player 3',
        points2 = json[thirdPlayerPointsColumn] ?? 0,
        player3 = json[fourthPlayerColumn]?[emailColumn] ?? 'player 4',
        points3 = json[fourthPlayerPointsColumn] ?? 0,
        user = userEmail {
    pointsUser = (user.contains(player0))
        ? points0
        : (user.contains(player1))
            ? points1
            : (user.contains(player2))
                ? points2
                : (user.contains(player3))
                    ? points3
                    : -1;
    winner = (pointsUser >= points0) &&
        (pointsUser >= points1) &&
        (pointsUser >= points2) &&
        (pointsUser >= points3);
  }
  DatabaseGame.fromRow(Map<String, dynamic> row, String userEmail)
      : id = row[idColumn] as int,
        name = row[nameColumn] as String,
        createdAt = DateTime.tryParse(row[createdAtColumn])?.toUtc() ??
            DateTime.now().toUtc(),
        maxTime = row[maxTimeColumn] as int,
        player0 = row[firstPlayerColumn][emailColumn] as String,
        points0 = row[firstPlayerPointsColumn] as int,
        player1 = row[secondPlayerColumn]?[emailColumn] ?? 'player 2',
        points1 = row[secondPlayerPointsColumn] ?? 0,
        player2 = row[thirdPlayerColumn]?[emailColumn] ?? 'player 3',
        points2 = row[thirdPlayerPointsColumn] ?? 0,
        player3 = row[fourthPlayerColumn]?[emailColumn] ?? 'player 4',
        points3 = row[fourthPlayerPointsColumn] ?? 0,
        user = userEmail {
    pointsUser = (user.contains(player0))
        ? points0
        : (user.contains(player1))
            ? points1
            : (user.contains(player2))
                ? points2
                : (user.contains(player3))
                    ? points3
                    : -1;
    winner = (pointsUser >= points0) &&
        (pointsUser >= points1) &&
        (pointsUser >= points2) &&
        (pointsUser >= points3);
  }

  @override
  String toString() =>
      'Game, ID = $id, name = $name, player0 = $player0, user = $user, userPoints = $pointsUser, createdAt = $createdAt';

  @override
  bool operator ==(covariant DatabaseGame other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const gameTable = 'games';
const idColumn = 'id';
const nameColumn = 'name';
const createdAtColumn = 'created_at';
const emailColumn = 'email';
const maxTimeColumn = 'max_time';
const firstPlayerColumn = 'player0';
const firstPlayerPointsColumn = 'player0_points';
const secondPlayerColumn = 'player1';
const secondPlayerPointsColumn = 'player1_points';
const thirdPlayerColumn = 'player2';
const thirdPlayerPointsColumn = 'player2_points';
const fourthPlayerColumn = 'player3';
const fourthPlayerPointsColumn = 'player3_points';
