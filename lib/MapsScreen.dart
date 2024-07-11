import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> { // Add this
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Content(),
      
    );
  }
}

Widget Content() {
  return FlutterMap(options: MapOptions(
      initialCenter: LatLng(1.2878, 103.8666),
      initialZoom: 11,
    interactionOptions: const InteractionOptions(
        flags: ~InteractiveFlag.doubleTapZoom
      )

  ), children: [openStreetMapTieLayer,
    MarkerLayer(markers: [
      Marker(
        point: LatLng(1.2878, 103.8666),
        width:60,
        height:60,
        alignment: Alignment.centerLeft,
        child: Icon(Icons.location_pin,
        size:60,
        color: Colors.red,
        )
      )
    ])
  ],);

}



TileLayer get openStreetMapTieLayer => TileLayer(

  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);