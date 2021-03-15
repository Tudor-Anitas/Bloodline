
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentersMap extends StatefulWidget{
  @override
  _GoogleMap createState() => _GoogleMap();
}

class _GoogleMap extends State<CentersMap>{
  Completer<GoogleMapController> mapController = Completer();
  Marker bm = Marker(
      markerId: MarkerId('bm'),
      position: LatLng(47.65901757989273, 23.56234562989272),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(47.6523, 23.5805), zoom: 12),
        onMapCreated: (GoogleMapController controller){
          mapController.complete(controller);
        },
        markers: {
          bm
        },
      ),
    );
  }

}