import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class maps extends StatefulWidget {
  const maps({Key? key}) : super(key: key);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  Position? _currentPosition;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = <Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(23, 45), zoom: 14),
          onMapCreated: _onMapCreated,
          markers: _markers,
          circles: {
            Circle(
                circleId: CircleId("0"),
                center: LatLng(23, 45),
                radius: 750,
                fillColor: Colors.green.withOpacity(0.5),
                strokeColor: Colors.green.withOpacity(0.5),
                strokeWidth: 1)
          },
        ),
      )),
    );
  }
}
