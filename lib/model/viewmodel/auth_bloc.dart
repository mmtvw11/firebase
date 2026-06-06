import 'dart:js_interop';
import 'dart:nativewrappers/_internal/vm_shared/lib/compact_hash.dart';

import 'package:firebaseapp/model/repo/users_reposytory.dart';
import 'package:firebaseapp/model/viewmodel/auth_even.dart';
import 'package:firebaseapp/model/viewmodel/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc <AuthEven, AuthState> {
  final AuthReposytory _repo;


  AuthBloc({required AuthReposytory repo})
  :_repo = repo,
  super(AuthInitial()) {
    on<AuthStarted>(_onSarted);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
  }


  Future<void> _onSarted(
    AuthStarted event, Emitter<AuthState> emit) async{
      await emit.forEach(_repo.AuthStateChanges,
       onData: (user) => user != null
       ?AuthAuthenticeted(user)
       :AuthUnauthenticeted(),
       );
    }


    Future<void> _onSignIn(
      AuthSignInRequested event,  Emitter<AuthState> emit) async{
        emit(AuthLoading());
        try {
          final user = await _repo.signIn(event.email, event.password);
          emit(AuthAuthenticeted(user));
        } on FirebaseAuthReposytory catch (e) {
          emit(AuthError(_mapError(e.code)));
        }
      }


      Future<void> _onSignUp(
        AuthSignUpRequested event, Emitter<AuthState> emit) async{
          emit(AuthLoading());
          try {
            final user = await _repo.signUp(event.email, event.password);
            emit(AuthAuthenticeted(user));
          }on FirebaseAuthReposytory catch (e) {
            emit(AuthError(_mapError(e.code)));
          }
        }

        Future<void> _onSignOut(
          AuthSignOutRequested event, Emitter<AuthState> emit) async{
            await _repo.signOut();
                      }
    String _mapError(String code) {
      return switch (code) {
        'user-not-fount' => 'пользователь не найден',
        'wrong-password' => 'не правильный пароль',
        'eamil-already-in-use' => 'email уже занят ',
        'weak-password' => 'слишком простой пароль',
        _ => 'что-то пошло не так'
      };
    }
}