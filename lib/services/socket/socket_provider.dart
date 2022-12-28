abstract class SocketProvider {
  Future<void> connect();

  void disconnect();

  Future<Map<String, dynamic>> create(Map<String, dynamic> data);

  Future<Map<String, dynamic>> join(Map<String, dynamic> data);

  Stream<Map<String, dynamic>> streamPlayers();

  void ready();

  void deletePlayer();

  void leave();

  Future<List<String>> get start;
}
