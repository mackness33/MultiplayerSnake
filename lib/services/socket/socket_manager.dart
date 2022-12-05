import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:developer' as devtools;

class SocketManager {
  final IO.Socket socket;

  SocketManager()
      : socket = IO.io(
          'http://10.0.2.2:3002',
          IO.OptionBuilder() // disable auto-connection
              // .setExtraHeaders({'foo': 'bar'}) // optional
              .setTransports(['websocket']).build(),
        );

  void init() {
    socket.onConnectError((data) {
      devtools.log('connetionError: $data');
      devtools.log(data.toString());
    });
    socket.onError((data) {
      devtools.log(data);
    });
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
  }
  //   socket.on('event', (data) => print(data));
  // void init () {
  //   socket.on('fromServer', (_) => print(_));
  // }

  Future<void> connect() async {
    socket.connect();
  }

  Future<void> disconnect() async {
    socket.onDisconnect((_) => print('disconnect'));
  }
}
