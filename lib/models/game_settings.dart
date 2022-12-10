class GameSettings {
  int indexPlayers;
  int indexTime;
  int indexPoints;
  String name;
  bool public;
  final List<String> _players = [];
  final List<int> _valuePlayers = [1, 2, 3];
  final List<int> _valueTime = [1, 2, 5];
  final List<int> _valuePoints = [100, 200, 400, 1000];
  final List<String> _fieldNames = [
    'name',
    'maxPlayers',
    'maxTime',
    'maxPoints',
    'public',
    'players',
  ];

  GameSettings()
      : indexPlayers = 0,
        indexTime = 0,
        indexPoints = 0,
        name = '',
        public = false;

  GameSettings.fromJson(Map<String, dynamic> json)
      : name = json['name'].cast<String>(),
        indexPlayers = json['indexPlayers'],
        indexTime = json['indexTime'],
        indexPoints = json['indexPoints'],
        public = json['public'];

  int get maxPlayers => _valuePlayers[indexPlayers];
  int get maxTime => _valueTime[indexTime];
  int get maxPoints => _valuePoints[indexPoints];
  List<String> get players => _players;
  List<int> get valuePlayers => _valuePlayers;
  List<int> get valueTime => _valueTime;
  List<int> get valuePoints => _valuePoints;

  Map<String, dynamic> toMap() {
    final fields = <dynamic>{name, maxPlayers, maxTime, maxPoints, public};
    return Map.fromIterables(_fieldNames, fields);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['indexPlayers'] = indexPlayers;
    data['indexTime'] = indexTime;
    data['indexPoints'] = indexPoints;
    data['public'] = public;
    data['players'] = _players;

    return data;
  }

  void addPlayer(String player) => _players.add(player);
  void removePlayer(String player) => _players.remove(player);
}
