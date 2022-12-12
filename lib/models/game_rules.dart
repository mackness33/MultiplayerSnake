class GameRules {
  int indexPlayers;
  int indexTime;
  int indexPoints;
  String name;
  bool public;
  final Player _player;
  final List<Player> _playersInTheRoom;
  final List<int> _valuePlayers = [1, 2, 3];
  final List<int> _valueTime = [1, 2, 5];
  final List<int> _valuePoints = [100, 200, 400, 1000];

  GameRules(String email)
      : indexPlayers = 0,
        indexTime = 0,
        indexPoints = 0,
        name = '',
        public = false,
        _player = Player.member(email),
        _playersInTheRoom = [];

  GameRules.fromJson(Map<String, dynamic> rules, List<String> playersEmail,
      String admin, Player player)
      : name = rules['name'],
        indexPlayers = rules['indexPlayers'],
        indexTime = rules['indexTime'],
        indexPoints = rules['indexPoints'],
        public = rules['public'],
        _player = player,
        _playersInTheRoom = [] {
    for (final email in playersEmail) {
      _playersInTheRoom
          .add(email == admin ? Player.admin(email) : Player.member(email));
    }
  }

  GameRules.forAdmin(GameRules rules, Player admin)
      : name = rules.name,
        indexPlayers = rules.indexPlayers,
        indexTime = rules.indexTime,
        indexPoints = rules.indexPoints,
        public = rules.public,
        _player = admin,
        _playersInTheRoom = [admin];

  int get maxPlayers => _valuePlayers[indexPlayers];
  int get maxTime => _valueTime[indexTime];
  int get maxPoints => _valuePoints[indexPoints];
  List<Player> get players => _playersInTheRoom;
  List<int> get valuePlayers => _valuePlayers;
  List<int> get valueTime => _valueTime;
  List<int> get valuePoints => _valuePoints;
  Player get player => _player;

  set isAdmin(bool value) => _player.isAdmin = value;

  Map<String, dynamic> createSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['indexPlayers'] = indexPlayers;
    data['indexTime'] = indexTime;
    data['indexPoints'] = indexPoints;
    data['public'] = public;
    data['player'] = _player.email;

    return data;
  }

  Map<String, dynamic> joinSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['player'] = _player.email;

    return data;
  }

  void addPlayer(String email, bool isAdmin) =>
      _playersInTheRoom.add(Player(email: email, isAdmin: isAdmin));
  void removePlayer(String email) =>
      _playersInTheRoom.removeWhere((Player player) => player.email == email);
}

// Define how a player looks like
class Player {
  String email;
  bool isAdmin;
  Player({required this.email, required this.isAdmin});
  Player.fromJson(Map<String, dynamic> json)
      : email = json['player'],
        isAdmin = false;

  Player.member(this.email) : isAdmin = false;
  Player.admin(this.email) : isAdmin = true;

  @override
  int get hashCode => email.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
