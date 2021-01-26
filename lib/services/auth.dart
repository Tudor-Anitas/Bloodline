import 'package:BloodLine/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() async{
    await _auth.signOut();

  }

  // sign in with email
  Future<String> signIn({String email, String password}) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  // register with email
  Future<String> signUp({String email, String password}) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      //? Put the user details into the firestore
      User user = _auth.currentUser;
      await DatabaseService().updateUserData("Tudor Anitas", "AB+", user.uid);

      return "New account created";
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  String getUID(){
    User user = _auth.currentUser;
    return user.uid;
  }
}