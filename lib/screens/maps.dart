
import 'dart:async';

import 'package:BloodLine/widgets/googleMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget{
  @override
  _MapsPage createState() => _MapsPage();
}

class _MapsPage extends State<Maps>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CentersMap()
      ),
    );
  }

}