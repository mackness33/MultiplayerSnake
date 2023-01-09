import 'package:flutter/foundation.dart';

@immutable
class DatabaseGame {
  final int id;
  final String name;
  final int maxTime;
  final String player0;
  final int points0;
  final String player1;
  final int points1;
  final String player2;
  final int points2;
  final String player3;
  final int points3;

  // DatabaseGame.fromSocket(Map<String, dynamic> json)
  //     : id = json[idColumn],
  //       name = json[nameColumn],
  //       maxTime = json[maxTimeColumn],
  //       player0 = json['first_player'][emailColumn],
  //       points0 = json['first_player_points'],
  //       player1 = json['second_player']?[emailColumn] ?? 'player 2',
  //       points1 = json['second_player_points'] ?? 0,
  //       player2 = json['third_player']?[emailColumn] ?? 'player 3',
  //       points2 = json['third_player_points'] ?? 0,
  //       player3 = json['fourth_player']?[emailColumn] ?? 'player 4',
  //       points3 = json['fourth_player_points']?[emailColumn] ?? 0;

  DatabaseGame(Map<String, dynamic> json)
      : id = json[idColumn] as int,
        name = json[nameColumn] as String,
        maxTime = json[maxTimeColumn] as int,
        player0 = json[firstPlayerColumn][emailColumn] as String,
        points0 = json[firstPlayerPointsColumn] as int,
        player1 = json[secondPlayerColumn]?[emailColumn] ?? 'player 2',
        points1 = json[secondPlayerPointsColumn] ?? 0,
        player2 = json[thirdPlayerColumn]?[emailColumn] ?? 'player 3',
        points2 = json[thirdPlayerPointsColumn] ?? 0,
        player3 = json[fourthPlayerColumn]?[emailColumn] ?? 'player 4',
        points3 = json[fourthPlayerPointsColumn] ?? 0;

  DatabaseGame.fromRow(Map<String, dynamic> row)
      : id = row[idColumn] as int,
        name = row[nameColumn] as String,
        maxTime = row[maxTimeColumn] as int,
        player0 = row[firstPlayerColumn] as String,
        points0 = row[firstPlayerPointsColumn] as int,
        player1 = row[secondPlayerColumn] ?? 'player 2',
        points1 = row[secondPlayerPointsColumn] ?? 0,
        player2 = row[thirdPlayerColumn] ?? 'player 3',
        points2 = row[thirdPlayerPointsColumn] ?? 0,
        player3 = row[fourthPlayerColumn] ?? 'player 4',
        points3 = row[fourthPlayerPointsColumn] ?? 0;

  @override
  String toString() => 'Game, ID = $id, name = $name, player0 = $player0';

  @override
  bool operator ==(covariant DatabaseGame other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const gameTable = 'games';
const idColumn = 'id';
const nameColumn = 'name';
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
