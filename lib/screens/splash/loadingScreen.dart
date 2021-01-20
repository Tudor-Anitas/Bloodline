import 'dart:async';

import 'package:BloodLine/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading>{

  //! Sets a timer until the Home page will open
  @override
  void initState() {
    super.initState();
    
    Timer(Duration(milliseconds: 3000),
            ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()))
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[800],
      body: Center(
        child: SpinKitPumpingHeart(
          color: Colors.white,
          size: 100.0,

        ),
      ),
    );
    
  }


}