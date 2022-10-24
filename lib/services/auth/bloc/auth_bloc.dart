import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/auth/auth_provider.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(((_, emit) async {
      await provider.initialize();
      await provider.initialSession;

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    }));

    on<AuthEventLogin>(((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.login(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoginFailure(e));
      }
    }));

    on<AuthEventLogout>(((event, emit) async {
      emit(const AuthStateLoading());

      try {
        await provider.logout();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    }));
  }
}
