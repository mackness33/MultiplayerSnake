class GameRules {
  int indexPlayers;
  int indexTime;
  int indexPoints;
  String name;
  bool public;
  String _player;
  final List<String> _others = [];
  final List<int> _valuePlayers = [1, 2, 3];
  final List<int> _valueTime = [1, 2, 5];
  final List<int> _valuePoints = [100, 200, 400, 1000];
  // final List<String> _fieldNames = [
  //   'name',
  //   'maxPlayers',
  //   'maxTime',
  //   'maxPoints',
  //   'public',
  //   'players',
  // ];

  GameRules(this._player)
      : indexPlayers = 0,
        indexTime = 0,
        indexPoints = 0,
        name = '',
        public = false;

  GameRules.fromJson(Map<String, dynamic> json)
      : name = json['name'].cast<String>(),
        indexPlayers = json['indexPlayers'],
        indexTime = json['indexTime'],
        indexPoints = json['indexPoints'],
        public = json['public'],
        _player = json['player'];

  int get maxPlayers => _valuePlayers[indexPlayers];
  int get maxTime => _valueTime[indexTime];
  int get maxPoints => _valuePoints[indexPoints];
  List<String> get others => _others;
  List<int> get valuePlayers => _valuePlayers;
  List<int> get valueTime => _valueTime;
  List<int> get valuePoints => _valuePoints;

  // Map<String, dynamic> createSettingsToJson() {
  //   final fields = <dynamic>{
  //     name,
  //     maxPlayers,
  //     maxTime,
  //     maxPoints,
  //     public,
  //     player
  //   };
  //   return Map.fromIterables(_fieldNames, fields);
  // }

  // Map<String, dynamic> joinSettingsToJson() {
  //   final fields = <dynamic>{
  //     name,
  //     player,
  //   };
  //   return Map.fromIterables(_fieldNames, fields);
  // }

  Map<String, dynamic> createSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['indexPlayers'] = indexPlayers;
    data['indexTime'] = indexTime;
    data['indexPoints'] = indexPoints;
    data['public'] = public;
    data['player'] = _player;

    return data;
  }

  Map<String, dynamic> joinSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['player'] = _player;

    return data;
  }

  void addPlayer(String player) => _others.add(player);
  void removePlayer(String player) => _others.remove(player);
}
