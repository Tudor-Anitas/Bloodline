
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  //? The key of the Firebase Cloud Messaging server to redirect the notifications
  String serverKey = 'AAAAFBD7AGw:APA91bF3bPDQmuwmopguTprh5l2YOuS6UUFlviBzHGNVPE9_gtfZ3xRbTUvjuJT0S_G6MtCvXjjts795usqFH2CM5_Q1o8uxrHBOuQxPDH2OJwLfZn3DV95VxJq9A7DhhQPsPuHl1sjK';

  /// Sends a http request at the Firebase Cloud Messaging API to display a notification
  /// on the targeted device through token
  Future<Map<String, dynamic>> sendJoinNotification(String token) async{
    print(token);
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey'
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Check your post',
            'title': 'Somebody just joined your cause!'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token
        }
      )
    );

    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        completer.complete(message);
      }
    );

    return completer.future;
  }

  Future<Map<String, dynamic>> debugNotification() async{
    try {
      await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode(
              <String, dynamic>{
                'notification': <String, dynamic>{
                  'body': 'Check your post',
                  'title': 'Somebody just joined your cause!'
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done'
                },
                'to': 'efcv0JTmQTq9vKkK0qMNp2:APA91bGKKWo3yhmLWyK0xky6fSxCF6K6QUpmx7uQdHNJsaRpv40TaIRea6BR1Tm2QkqBxYMfP8TQBG9-XF-_E3yj0g3dnTnchztwQSjzoe4Q61dEh3PLhvNK-FsqYRGF7Cf66xMPd68w'
              }
          )
      );

      final Completer<Map<String, dynamic>> completer = Completer<
          Map<String, dynamic>>();

      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            completer.complete(message);
          }
      );

      return completer.future;
    } catch(e){
      print(e);
    }


  }

  /// Get all users that have the specified bloodtype and are in the same city
  /// if there isn't any user in the same city, it will go to the global posts that every user can see
  /// Iterate through the list and send a notification to all of them
  Future<Map<String, dynamic>> sendSimilarBloodJoinNotification(String bloodtype) async{

    String blood = "";
    switch (bloodtype) {
      case 'O+':
        blood = 'Opos';
        break;
      case 'O-':
        blood = 'Oneg';
        break;
      case 'A+':
        blood = 'Apos';
        break;
      case 'A-':
        blood = 'Aneg';
        break;
      case 'B+':
        blood = 'Bpos';
        break;
      case 'B-':
        blood = 'Bneg';
        break;
      case 'AB+':
        blood = 'ABpos';
        break;
      case 'AB-':
        blood = 'ABneg';
        break;
    }
    print(blood);
    String toParams = '/topics/' + blood;

    final response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        },
        body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': 'New Transfusion Needed!',
                'title': 'Someone with your blood type needs your help'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': '$toParams'
            }
        )

    );
    if(response.statusCode != 200){
      print("couldn't send the notification");
    }
    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

  Future getAllTopics() async{
    String token = await FirebaseMessaging().getToken();
    final response = await http.get(
        'https://iid.googleapis.com/iid/info/$token?details=true',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        }
    );
    print(response.body);
  }

}





