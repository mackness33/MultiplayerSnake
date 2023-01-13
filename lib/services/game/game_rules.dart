import "dart:developer" as devtools show log;

class GameRules {
  int indexPlayers;
  int indexTime;
  int indexPoints;
  String room;
  bool public;
  final Player _player;
  Set<Player> _playersInTheRoom;
  final List<int> _valuePlayers = [2, 3, 4];
  final List<int> _valueTime = [0, 1, 2, 5];
  final List<int> _valuePoints = [0, 2, 20, 30, 50];

  GameRules(String email)
      : indexPlayers = 0,
        indexTime = 0,
        indexPoints = 0,
        room = '',
        public = false,
        _player = Player.member(email),
        _playersInTheRoom = <Player>{};

  GameRules.fromJson(Map<String, dynamic> rules, List<String> playersEmail,
      String admin, this._player, this.room)
      : indexPlayers = rules['indexPlayers'],
        indexTime = rules['indexTime'],
        indexPoints = rules['indexPoints'],
        public = rules['public'],
        _playersInTheRoom = <Player>{} {
    for (final email in playersEmail) {
      _playersInTheRoom
          .add(email == admin ? Player.admin(email) : Player.member(email));
    }
  }

  GameRules.forAdmin(GameRules rules, Player admin)
      : room = rules.room,
        indexPlayers = rules.indexPlayers,
        indexTime = rules.indexTime,
        indexPoints = rules.indexPoints,
        public = rules.public,
        _player = admin,
        _playersInTheRoom = <Player>{admin};

  int get maxPlayers => _valuePlayers[indexPlayers];
  int get maxTime => _valueTime[indexTime];
  int get maxPoints => _valuePoints[indexPoints];
  List<Player> get players => _playersInTheRoom.toList();
  List<int> get valuePlayers => _valuePlayers;
  List<int> get valueTime => _valueTime;
  List<int> get valuePoints => _valuePoints;
  Player get player => _player;

  set isAdmin(bool value) => _player.isAdmin = value;
  bool get isAdmin => _player.isAdmin;

  Map<String, dynamic> createSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['room'] = room;
    data['indexPlayers'] = indexPlayers;
    data['indexTime'] = indexTime;
    data['indexPoints'] = indexPoints;
    data['maxPlayers'] = maxPlayers;
    data['maxTime'] = maxTime;
    data['maxPoints'] = maxPoints;
    data['public'] = public;
    data['player'] = _player.email;

    return data;
  }

  Map<String, dynamic> joinSettingsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['room'] = room;
    data['player'] = _player.email;

    return data;
  }

  void updatePlayers(Set<String> newPlayers) {
    devtools.log('players in the room: ${_playersInTheRoom.toString()}');
    devtools.log('newPlayers: ${newPlayers.toString()}');
    if (_playersInTheRoom.length > newPlayers.length) {
      devtools.log('Deleting players');
      _playersInTheRoom.retainAll(newPlayers
          .map((player) => Player(email: player, isAdmin: false))
          .toSet());
    } else if (_playersInTheRoom.length < newPlayers.length) {
      devtools.log('Adding players');
      _playersInTheRoom.add(Player(
          email: newPlayers
              .difference(
                  _playersInTheRoom.map((player) => player.email).toSet())
              .first,
          isAdmin: false));
    }

    devtools
        .log('At the end players in the room: ${_playersInTheRoom.toString()}');
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

  @override
  String toString() => 'Player: email = $email, isAdmin = $isAdmin';
}
