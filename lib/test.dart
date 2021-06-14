import 'package:BloodLine/services/auth.dart';
import 'package:BloodLine/services/database.dart';
import 'package:BloodLine/services/local_notifications.dart';
import 'package:BloodLine/services/notifications.dart';
import 'package:BloodLine/widgets/customDialog.dart';
import 'package:BloodLine/widgets/outlineButton.dart' as outlineButton;
import 'package:BloodLine/widgets/customListTile.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class Testpage extends StatefulWidget{

  @override
  _TestpageState createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {


  double _postsHeight = 0;
  double _postsWidth = 0;
  double _postsXOffset = 0; // the offset of the login page to the top side
  double _postsYOffset = 0;// the offset of the login page to the left side
  double _postsOpacity = 1;
  Radius _postsBottomLeft = Radius.circular(0);
  Radius _postsBottomRight = Radius.circular(0);


  //? To be added to the home page
  double _postPageHeight = 0;
  double _postPageWidth = 0;
  double _postXOffset = 0;
  double _postYOffset = 0;
  // Fields that change dynamically when a Post button is pressed
  String _postBloodType = '';
  String _postDate = '';
  String _postDescription = '';
  String _postExpirationDate = '';
  String _postHospital = '';
  String _postAuthor = '';
  String _postCity = '';

  double windowHeight;
  double windowWidth;

  int _pageState = 0;


  @override
  void initState() {
    super.initState();

  }



  // places api to transfusion centers
  // https://maps.googleapis.com/maps/api/place/textsearch/json?query=transfuzie+in+Baia%Mare&key=AIzaSyCfbIFx8Ph6cMRDhnyX0R1asLz8QVeMypo
  @override
  Widget build(BuildContext context) {


    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;


    switch(_pageState){
      case 0:
        _postPageHeight = 0;
        _postBloodType = '';
        _postDate = '';
        _postDescription = '';
        _postExpirationDate = '';
        _postHospital = '';
        _postAuthor = '';

        break;
      case 1:
        _postPageHeight = windowHeight/1.4;
        _postXOffset = 0;
        _postYOffset = 0;
        break;
    }
    final snackbar1 = SnackBar(content: Text('You already joined this cause!'));
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DatabaseService().removeExpiredPosts();
        }
      ),
      body: Container()

    );

  }
  Future<Position> _userLocation(){
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  }
}
