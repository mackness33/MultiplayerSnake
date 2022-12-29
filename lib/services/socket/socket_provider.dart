abstract class SocketProvider {
  Future<void> connect();

  void disconnect();

  Future<Map<String, dynamic>> create(Map<String, dynamic> data);

  Future<Map<String, dynamic>> join(Map<String, dynamic> data);

  Stream<Map<String, dynamic>> streamPlayers();

  Stream<Map<String, dynamic>> streamPoints();

  void ready();

  void end();

  void eat(bool isSpecial);

  void deletePlayer();

  void leave();

  Future<List<String>> get start;
}
