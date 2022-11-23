import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  final IO.Socket socket;

  SocketManager()
      : socket = IO.io(
          'http://localhost:3000',
          IO.OptionBuilder()
              .disableAutoConnect() // disable auto-connection
              // .setExtraHeaders({'foo': 'bar'}) // optional
              .build(),
        );

  // void init () {
  //   socket.on('event', (data) => print(data));
  //   socket.on('fromServer', (_) => print(_));
  // }

  Future<void> connect() async {
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
  }

  Future<void> disconnect() async {
    socket.onDisconnect((_) => print('disconnect'));
  }
}
