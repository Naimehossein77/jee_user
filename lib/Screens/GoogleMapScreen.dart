import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  // const GoogleMapScreen({Key? key}) : super(key: key);
  String lat, lang;

  GoogleMapScreen({required this.lat, required this.lang});

  @override
  _GoogleMapScreenState createState() =>
      _GoogleMapScreenState(lat: lat, lang: lang);
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  String lat, lang;

  _GoogleMapScreenState({required this.lat, required this.lang});

  Set<Marker> _marker = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _marker.add(
          Marker(markerId: MarkerId('id-1'), position: LatLng(mLong, mLat)));
    });
  }

  late double mLat, mLong;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mLat = double.parse(lat);
    mLong = double.parse(lang);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _marker,
            initialCameraPosition:
                CameraPosition(target: LatLng(mLong, mLat), zoom: 16)),
      ),
    );
  }
}
