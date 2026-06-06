import 'package:firebaseapp/model/repo/users_reposytory.dart';
import 'package:firebaseapp/model/viewmodel/auth_bloc.dart';
import 'package:firebaseapp/model/viewmodel/auth_even.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:DefoultFirebaseOptions.currentPlatfrom
  );
  final authRepo = FirebaseAuthReposytory();

 runApp(
  BlocProvider(
    create: (_) => AuthBloc(repo: AuthRepe)
    ..add(AuthStarted()),
    child: MainApp(),
    )
 );
}


class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return 
  }
}