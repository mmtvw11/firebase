import 'package:firebaseapp/model/viewmodel/auth_bloc.dart';
import 'package:firebaseapp/model/viewmodel/auth_even.dart';
import 'package:firebaseapp/model/viewmodel/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state){
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message))
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'email'
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
              ),

              SizedBox(height: 24),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(onPressed: state is AuthLoading ?null 
                  :() => context.read<AuthBloc>().add(
                    AuthSignInRequested(_emailCtrl.text, _passCtrl.text)
                  ),
                  child: state is AuthLoading
                  ? CircularProgressIndicator()
                  :Text('войти')
                  );
                }
              )

            ],
          ),),
          
      ),
      );
  }
}