abstract class SocketProvider {
  Future<void> connect();

  void disconnect();

  Future<Map<String, dynamic>> create(Map<String, dynamic> data);

  Future<Map<String, dynamic>> join(Map<String, dynamic> data);

  Stream<Map<String, dynamic>> streamPlayers();

  Stream<Map<String, dynamic>> streamPoints();

  void ready();

  void endGame();

  void eat(bool isSpecial);

  void removePlayer(String deletedUserEmail);

  void leave();

  Future<List<String>> get start;

  Future<bool> get end;

  Future<Map<String, dynamic>> get results;

  Stream<List<String>> get waitingPlayersStream;
}
