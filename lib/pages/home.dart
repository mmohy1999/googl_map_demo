import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  var myMarkers = HashSet<Marker>();
  late BitmapDescriptor customMarker;
  late BitmapDescriptor destinationMarker;
  List<Polyline> myPolyline = [];

  @override
  void initState() {
    super.initState();
    getCustomMarker().then((value) =>createPloyLine() );

  }
  Future getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/location-pin.png');
    destinationMarker=await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/destination_map_marker.png');
  }

  createPloyLine() {
    myMarkers.add(Marker(markerId: const MarkerId('10'),
      icon:destinationMarker,position: const LatLng(30.0744, 31.2557)));
    myPolyline.add(
      const Polyline(
          polylineId: PolylineId('1'),
          color: Colors.purple,
          width: 3,
          points: [
            LatLng(30.0444, 31.2357),
            LatLng(30.0744, 31.2557),
          ],
          ),
    );
  }

  Set<Polygon> myPolygon() {
    var polygonCorners = <LatLng>[];
    polygonCorners.add(const LatLng(30.0444, 31.2357));
    polygonCorners.add(const LatLng(30.0544, 31.2557));
    polygonCorners.add(const LatLng(30.0554,31.2757));
    polygonCorners.add(const LatLng(30.1554,31.2757));
    polygonCorners.add(const LatLng(30.0444, 31.2357));

    var polygonSet = <Polygon>{};
    polygonSet.add(
      Polygon(
        polygonId: const PolygonId('1'),
        points: polygonCorners,
        strokeWidth: 4,
        strokeColor: Colors.black54,

        fillColor: Colors.transparent
      ),
    );

    return polygonSet;
  }

  Set<Circle> myCircles = {
    const Circle(
      circleId: CircleId('1'),
      center: LatLng(30.0444, 31.2357),
      radius: 1000,
      strokeWidth: 3,
      strokeColor: Colors.lightBlue
    )
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Google Map'),
      ),
      body:  GoogleMap(
        initialCameraPosition: const CameraPosition(
            target: LatLng(30.0444, 31.2357), zoom: 14),
          onMapCreated: (controller) {
            setState(() {
              myMarkers.add(
                 Marker(
                  markerId: const MarkerId('1'),
                  position: const LatLng(30.0444, 31.2357),
                  infoWindow: InfoWindow(title: 'cairo',snippet: 'Tahrir square',onTap: (){
                  }),
                   icon: customMarker,
                   draggable: true,
                   onDragEnd: (value) {
                     
                   },
                ),
              );
            });
          },
        markers: myMarkers,
        polygons: myPolygon(),
        circles: myCircles,
        polylines: myPolyline.toSet(),
      ),
    );
  }
}
