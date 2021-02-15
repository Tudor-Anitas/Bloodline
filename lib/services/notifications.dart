
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  //? The key of the Firebase Cloud Messaging server to redirect the notifications
  String serverKey = 'AAAAFBD7AGw:APA91bF3bPDQmuwmopguTprh5l2YOuS6UUFlviBzHGNVPE9_gtfZ3xRbTUvjuJT0S_G6MtCvXjjts795usqFH2CM5_Q1o8uxrHBOuQxPDH2OJwLfZn3DV95VxJq9A7DhhQPsPuHl1sjK';

  /**
   *! Sends a http request at the Firebase Cloud Messaging API to display a notification
   *! on the targeted device through token
   */
  Future<Map<String, dynamic>> sendJoinNotification(String token) async{
    print('Join message sent');
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
    print("After http post");
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        completer.complete(message);
      }
    );

    return completer.future;
  }


}




