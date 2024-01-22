import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jee_user/Models/directions_repository.dart';
import 'package:location/location.dart';

class GetDirection extends StatefulWidget {
  GetDirection({
    Key? key,
    required this.position,
  }) : super(key: key);
  LatLng position;

  @override
  _GetDirectionState createState() => _GetDirectionState();
}

class _GetDirectionState extends State<GetDirection> {
  late StreamSubscription<LocationData> geo, dp;
  static var _initialCameraPosition;
  late GoogleMapController _googleMapController;
  Marker _origin = Marker(markerId: MarkerId('origin')), _destination = Marker(markerId: MarkerId('destination'));
  late LatLng position, myPosition;
  late LocationData currentLocation;
  var _info;
  late BitmapDescriptor icon;
  late List<LatLng> poly;
  void initState() {
    poly = [];
    super.initState();
    getCurrentLocation();
    _initialCameraPosition = CameraPosition(target: widget.position, zoom: 16);
    _destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'My Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: widget.position,
    );
    getLiveLocation();
    myPosition = widget.position;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), 'assets/location.png')
        .then((value) => icon = value);
  }

//////////////////LIVE LOCATION///////////////////////////////////////////////
  void getLiveLocation() async {
    dp = Location.instance.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      // myPosition = LatLng(currentLocation.latitude!, currentLocation.latitude!);
      this.currentLocation = currentLocation;
      double lat = currentLocation.latitude!;
      double lang = currentLocation.longitude!;
      myPosition = LatLng(lat, lang);

      _addMyMarker(myPosition);
      setState(() {});
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: myPosition, zoom: 16)));
    });

    // geo = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, intervalDuration: Duration(seconds: 2))
    //     .listen((Position newPos) {
    //   print(newPos == null ? 'Unknown' : newPos.latitude.toString() + ', ' + newPos.longitude.toString());
    //   myPosition = LatLng(newPos.latitude, newPos.longitude);
    //   _addMyMarker(myPosition);
    //   setState(() {});
    //   _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: myPosition, zoom: 16)));
    // });
  }

  void dispose() {
    super.dispose();
    // geo.cancel();
    dp.cancel();
    _googleMapController.dispose();
  }

  getCurrentLocation() async {
    Location location = new Location();

    var pos = await Location.instance.getLocation();
    this.currentLocation = pos;
    double lat = currentLocation.latitude!;
    double lng = currentLocation.longitude!;
    myPosition = LatLng(lat, lng);

    _addMyMarker(myPosition);

    //GET DIRECTIONS/////////////////
    final directions =
        await DirectionsRepository(dio: Dio()).getDirections(origin: myPosition, destination: widget.position);
    _info = directions!;
    _info.polylinePoints.forEach((element) {
      print(element);
      poly.add(LatLng(element.latitude, element.longitude));
    });

    setState(() {
      print(directions);
    });

    return pos;
  }

  void _addMarker(LatLng pos) async {
    // print(Geolocator.distanceBetween(pos.latitude, pos.longitude, widget.position.latitude, widget.position.longitude));
    position = pos;
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'My location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
  }

  void _addMyMarker(LatLng pos) {
    print('add mymarker called');
    // print(Geolocator.distanceBetween(pos.latitude, pos.longitude, widget.position.latitude, widget.position.longitude));
    // setState(() {
    _origin = Marker(
      rotation: currentLocation.heading!,
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'My location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

      // BitmapDescriptor.defaultMarkerWithHue(
      //   BitmapDescriptor.hueBlue,
      // ),
      position: myPosition,
    );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your location'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              _origin,
              _destination,
            },
            // onTap: _addMarker,
            polylines: {
              if (_info != null && !poly.isEmpty)
                Polyline(polylineId: PolylineId('overview_polyline'), color: Colors.blue, width: 10, points: poly)
            },
          ),
          if (_info != null)
            Positioned(
                top: 20,
                child: Container(
                  // width: MediaQuery.of(context).size.width * .70,
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)]),
                  child: Text('${_info.totalDistance}, +${_info.totalDuration}'),
                ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          var pos = widget.position;
          widget.position = LatLng(pos.latitude, pos.longitude);

          _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: myPosition, zoom: 16)));
          setState(() {
            _origin = Marker(
              markerId: const MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'My location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              position: myPosition,
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
