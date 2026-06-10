import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/firebase_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService = FirebaseService();

  AuthBloc() : super(const AuthInitial()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Слушаем изменения состояния аутентификации
    _firebaseService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.uid,
          email: user.email ?? '',
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> _onSignUp(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _firebaseService.signUp(
        event.email,
        event.password,
      );

      emit(AuthAuthenticated(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _firebaseService.signIn(
        event.email,
        event.password,
      );

      emit(AuthAuthenticated(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _firebaseService.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
