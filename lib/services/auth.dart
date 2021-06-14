import 'dart:convert';

import 'package:BloodLine/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{
  final _oldauth;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  AuthService(this._oldauth);


  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() async{

    var user = _auth.currentUser;

    if(user.providerData[0].providerId == 'google.com'){
      await googleSignIn.disconnect();
    } else if(user.providerData[0].providerId == 'facebook.com'){
      await FacebookAuth.instance.logOut();
    }
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

      return "New account created";
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }
  Future<bool> signInWithGoogle() async{

    bool userExists = false;

    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    print('compare emails: ${googleSignInAccount.email}');
    if(await DatabaseService().userExists(googleSignInAccount.email)){
      print('it is already registered');
      userExists = true;
    }

    if(googleSignInAccount != null){
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      try{
        var result = await _auth.signInWithCredential(credential);
        var user = _auth.currentUser;
      }catch (e){
        print(e);
      }

      if(userExists){
        return true;
      }
      return false;
    }
  }

  Future<bool> signInWithFacebook() async{
    bool userExists = false;

    try {
      final facebookResult = await FacebookAuth.instance.login();
      if (facebookResult.status == FacebookAuthLoginResponse.ok) {
        //! Get the account data from fb
        final facebookAccount = await FacebookAuth.instance.getUserData();
        //! Put the info into a map
        Map<String, dynamic> accountInfo = Map<String, dynamic>.from(facebookAccount);
        //! Check if the user already exists into firebase
        if(await DatabaseService().userExists(accountInfo['email'])){
          print('it is already registered');
          userExists = true;
        }
        
        AuthCredential credential = FacebookAuthProvider.credential(facebookResult.accessToken.token);
        try{
          var result = await _auth.signInWithCredential(credential);
          var user = _auth.currentUser;
          user.updateProfile(photoURL: accountInfo['picture']['data']['url']);
        }
        catch(e){
          print(e);
        }
      }
    }
    catch (e){
      print(e);
    }
    if(userExists){
      return true;
    }
    return false;
  }

  Future updateNameAndBloodType(String name, String bloodtype, String city, String token, String userImage) async{
    //? Put the user details into the firestore
    User user = _auth.currentUser;

    await DatabaseService().updateUserData(name, bloodtype, city, user.uid, token, user.email, userImage);
  }

}