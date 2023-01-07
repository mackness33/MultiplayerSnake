import 'package:bloc/bloc.dart';
import 'package:multiplayersnake/services/auth/auth_provider.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_event.dart';
import 'package:multiplayersnake/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // signup
    on<AuthEventSignup>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);

        emit(const AuthEventNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventShouldSignup>(((_, emit) async {
      emit(const AuthStateRegistering(null));
    }));

    // initialize
    on<AuthEventInitialize>(((_, emit) async {
      await provider.initialize();
      await provider.initialSession;

      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user));
      }
    }));

    // login
    on<AuthEventLogin>(((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.login(email: email, password: password);

        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        if (!user.isEmailVerified) {
          emit(const AuthEventNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }

        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    }));

    // logout
    on<AuthEventLogout>(((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    }));
  }
}
