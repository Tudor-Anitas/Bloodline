import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference userPosts = FirebaseFirestore.instance.collection('posts');
  /// Updates information about a newly registered user
  Future updateUserData(String name, String bloodtype, String uid, String token, String email) async{
    return await userDataCollection.doc(uid).set({
      'name': name,
      'bloodtype': bloodtype,
      'deviceToken' : token,
      'email' : email
    });
  }
  /// Adds the created post into the user's collection
  Future addPostToUser(String name, String bloodtype, String hospital, String date, String expirationDate, String description, String uid, String deviceToken) async{
    return await userDataCollection.doc(uid).collection('posts').add({
      'name': name,
      'bloodtype': bloodtype,
      'hospital': hospital,
      'date': date,
      'expiration-date': expirationDate,
      'description': description,
      'user-id': uid,
      'device-token': deviceToken,
      'people-joined': ''
    });
  }


  /// Adds a [post] to the general collection into the Firestore database
  Future addPost(String name, String bloodtype, String hospital, String date, String expirationDate, String description, String uid, String deviceToken) async{
    return await userPosts.doc().set({
      'name': name,
      'bloodtype': bloodtype,
      'hospital': hospital,
      'date': date,
      'expiration-date': expirationDate,
      'description': description,
      'user-id': uid,
      'device-token': deviceToken,
      'people-joined': ''
    });
  }

  Future addPeopleToPost(String uid, String postid) async{

    //! Create collection in individual post
    await userPosts.doc(postid).collection('people-joined').add({
      'user-id': uid,
    });
  }

  /// Checks if a user is already joined in the post.
  /// Verifies [uid] in the people-joined collection of the [postid] post.
  /// Returns true if the user was found, false otherwise
  Future<bool> isAlreadyJoined(String uid, String postid) async{
    //! This statement goes to the posts/postid/people-joined/
    //! And gets all the documents from that collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').doc(postid).collection('people-joined').get();
    //! Iterate through the collection to see if the uid matches
    for(final element in snapshot.docs){
      if(element.data().values.first.toString() == uid){
        return true;
      }
    }
    return false;
  }

}