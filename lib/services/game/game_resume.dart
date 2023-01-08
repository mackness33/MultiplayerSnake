class GameResume {
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

  GameResume(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        maxTime = json['max_time'],
        player0 = json['first_player']['email'],
        points0 = json['first_player_points'],
        player1 = json['second_player']?['email'] ?? 'player 2',
        points1 = json['second_player_points'] ?? 0,
        player2 = json['third_player']?['email'] ?? 'player 3',
        points2 = json['third_player_points'] ?? 0,
        player3 = json['fourth_player']?['email'] ?? 'player 4',
        points3 = json['fourth_player_points']?['email'] ?? 0;
}
