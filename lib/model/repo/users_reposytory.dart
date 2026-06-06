

abstract class AuthReposytory {
  Stream<Usermodel?> get AuthStateChanges;
  Future<UserModel> signIn(String email,String password);
  Future<UserModel> signUp(String email,String password);
  Future<UserModel> signOut();
}


class FirebaseAuthReposytory implements AuthReposytory{
  final _auth = FirebaseAuth.instance;

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map(
      (user) => user != null 
          ? UserModel.fromFireBase(user)
          :null
    );
    return UserModel.fromFireBase(cred. user!);
  }

  @override
  Future <void> signOut() => _auth.signOut();

  @override
   Future<UserModel> signUp(String email, String passsword) async{
    final cred = await _auth.createuserWithEmailAndPassword(
      email: email, passsword: passsword);
      return UserModel.fromFirebase(cred.user!);
   }
  }
  
