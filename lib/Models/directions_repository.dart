import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;

  DirectionsRepository({required Dio dio}) : _dio = dio;

  Future<Directions?> getDirections({required LatLng origin, required LatLng destination}) async {
    var response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': 'AIzaSyDuIBJ8pL7_iqWjepTybm6teuRxaJdn-N0'
    });
    var value;
    log('in dio');
    log(response.data.toString());
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  const Directions(
      {required this.bounds, required this.polylinePoints, required this.totalDistance, required this.totalDuration});
  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) ;
    final data = Map<String, dynamic>.from(map['routes'][0]);

    //Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
        southwest: LatLng(southwest['lat'], southwest['lng']), northeast: LatLng(northeast['lat'], northeast['lng']));
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }
    return Directions(
        bounds: bounds,
        polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration);
  }
}
