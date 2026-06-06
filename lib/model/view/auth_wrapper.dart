import 'package:firebaseapp/model/view/login_page.dart';
import 'package:firebaseapp/model/viewmodel/auth_bloc.dart';
import 'package:firebaseapp/model/viewmodel/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>
    (builder:(contextt, state) {
      if (state is AuthInitial || state is AuthLoading) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()
          ),
        );
      }

      if (state is AuthAuthenticeted) {
        return Scaffold(
          body: Center(
            child: Text('home page'),
          ),
        );
      }
      return LoginPage();
    } 
    );
  }
}