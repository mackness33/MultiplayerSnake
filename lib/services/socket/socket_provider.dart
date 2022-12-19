abstract class SocketProvider {
  Future<void> connect();

  void disconnect();

  Future<Map<String, dynamic>> create(Map<String, dynamic> data);

  Future<Map<String, dynamic>> join(Map<String, dynamic> data);

  Stream<Map<String, dynamic>> streamPlayers();

  void ready(String email, String room);

  void deletePlayer(String email, String room);

  Future<void> get start;
}
