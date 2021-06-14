
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentersMap extends StatefulWidget{
  @override
  _GoogleMap createState() => _GoogleMap();
}

class _GoogleMap extends State<CentersMap>{
  Completer<GoogleMapController> mapController = Completer();
  double zoomValue = 12;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(47.6523, 23.5805), zoom: 12),
            zoomControlsEnabled: true,
            onCameraMove: (CameraPosition cameraPosition){
              print(cameraPosition.zoom);
            },
            onMapCreated: (GoogleMapController controller){
              mapController.complete(controller);
            },
            markers: {
              bm, brasov, bucuresti, cluj, sm, timisoara, oradea, sibiu,
              sfGheorge, botosani, albaIulia, targuMures, bucuresti2, bistrita,
              iasi, arad, targuJiu, targoviste, ploiesti, bacau
            },
          ),
        ),
      ]
    );
  }

  
  Future<Position> _userLocation(){
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  ///////////////////////////////// List of markers
  Marker bm = Marker(
      markerId: MarkerId('bm'),
      position: LatLng(47.6576718, 23.5610185),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker brasov = Marker(
      markerId: MarkerId('brasov'),
      position: LatLng(45.6517396, 25.5990806),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker bucuresti = Marker(
      markerId: MarkerId('bucuresti'),
      position: LatLng(44.4538567, 26.079771),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker cluj = Marker(
      markerId: MarkerId('cluj'),
      position: LatLng(46.7758616, 23.597914),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker sm = Marker(
      markerId: MarkerId('sm'),
      position: LatLng(47.78333800000001, 22.8605037),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker timisoara = Marker(
      markerId: MarkerId('timisoara'),
      position: LatLng(45.737215, 21.2399522),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker oradea = Marker(
      markerId: MarkerId('oradea'),
      position: LatLng(47.0643578, 21.947611),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker sibiu = Marker(
      markerId: MarkerId('sibiu'),
      position: LatLng(45.7944114, 24.1590553),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker sfGheorge = Marker(
      markerId: MarkerId('sfGheorghe'),
      position: LatLng(45.86140229999999, 25.7903073),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker botosani = Marker(
      markerId: MarkerId('botosani'),
      position: LatLng(47.7419331, 26.6615954),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker albaIulia = Marker(
      markerId: MarkerId('albaIulia'),
      position: LatLng(46.0722728, 23.5574536),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker targuMures = Marker(
      markerId: MarkerId('targuMures'),
      position: LatLng(46.5605824, 24.5830881),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker bucuresti2 = Marker(
      markerId: MarkerId('bucuresti2'),
      position: LatLng(44.4537325, 26.0799748),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker bistrita = Marker(
      markerId: MarkerId('bistrita'),
      position: LatLng(47.1295555, 24.4871783),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker iasi = Marker(
      markerId: MarkerId('iasi'),
      position: LatLng(47.1696624, 27.5825683),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker arad = Marker(
      markerId: MarkerId('arad'),
      position: LatLng(46.1828046, 21.3068237),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker targuJiu = Marker(
      markerId: MarkerId('targuJiu'),
      position: LatLng(45.03292889999999, 23.2742283),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker targoviste = Marker(
      markerId: MarkerId('targoviste'),
      position: LatLng(44.9191312, 25.457063),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker ploiesti = Marker(
      markerId: MarkerId('ploiesti'),
      position: LatLng(44.9424473, 25.992552),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
  Marker bacau = Marker(
      markerId: MarkerId('bacau'),
      position: LatLng(46.5594662, 26.910772),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );
}

