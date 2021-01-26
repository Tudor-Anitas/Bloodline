import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Post.dart';

class DatabaseService{

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference userPosts = FirebaseFirestore.instance.collection('posts');
  Future updateUserData(String name, String bloodtype, String uid) async{
    return await userDataCollection.doc(uid).set({
      'name': name,
      'bloodtype': bloodtype,
    });
  }
  //? Adds the created post into the user's collection
  Future addPostToUser(String name, String bloodtype, String hospital, String date, String expirationDate, String description, String uid) async{
    return await userDataCollection.doc(uid).collection('posts').add({
      'name': name,
      'bloodtype': bloodtype,
      'hospital': hospital,
      'date': date,
      'expiration-date': expirationDate,
      'description': description
    });
  }

  //? Adds the post into the general collection
  Future addPost(String name, String bloodtype, String hospital, String date, String expirationDate, String description, String uid) async{
    return await userPosts.doc().set({
      'name': name,
      'bloodtype': bloodtype,
      'hospital': hospital,
      'date': date,
      'expiration-date': expirationDate,
      'description': description
    });
  }


}