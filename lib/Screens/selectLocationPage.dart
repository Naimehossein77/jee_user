import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SelectLocationPage extends StatefulWidget {
  SelectLocationPage({Key? key, required this.position, required this.changePosition}) : super(key: key);
  LatLng position;
  Function changePosition;
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  static var _initialCameraPosition;
  late GoogleMapController _googleMapController;
  Marker _origin = Marker(markerId: MarkerId('origin')), _destination = Marker(markerId: MarkerId('destination'));
  late LatLng position;
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: widget.position, zoom: 16);
    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'My location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: widget.position,
    );
  }

  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  getCurrentLocation() async {
    var pos = await Location.instance.getLocation();

    setState(() {});
    return pos;
  }

  void _addMarker(LatLng pos) {
    position = pos;
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'My location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: pos,
      );
    });
    widget.changePosition(pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your location'),
        backgroundColor: Colors.deepOrange,
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin,
          if (_destination != null) _destination,
        },
        onTap: _addMarker,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          var pos = await getCurrentLocation();
          widget.position = LatLng(pos.latitude, pos.longitude);

          _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: widget.position, zoom: 16)));
          setState(() {
            _origin = Marker(
              markerId: const MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'My location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              position: widget.position,
            );
          });
        },
        child: Icon(
          Icons.center_focus_strong,
          color: Colors.black,
        ),
      ),
    );
  }
}
