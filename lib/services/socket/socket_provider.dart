import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class SocketProvider {
  // void init () {
  //   socket.on('event', (data) => print(data));
  //   socket.on('fromServer', (_) => print(_));
  // }

  Future<void> connect();

  Future<void> disconnect();
}
