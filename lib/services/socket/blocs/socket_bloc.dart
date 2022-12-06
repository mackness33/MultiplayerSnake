import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_event.dart';
import 'package:multiplayersnake/services/socket/blocs/socket_state.dart';
import 'package:multiplayersnake/services/socket/socket_service.dart';
import 'dart:developer' as devtools;

import 'package:multiplayersnake/services/socket/socket_provider.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketBloc(SocketProvider socket) : super(const SocketStateDisconnected()) {
    // connect
    on<SocketEventConnection>((event, emit) async {
      emit(const SocketStateConnectionInProgress());
      await socket.connect();
      emit(const SocketStateUninitialized());
    });

    // connect
    on<SocketEventInitizialization>((event, emit) async {
      emit(const SocketStateReady());
    });

    // disconnect
    on<SocketEventDisconnection>(((event, emit) {
      socket.disconnect();
      emit(const SocketStateDisconnected());
    }));
  }
}
