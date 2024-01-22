import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'BottomNavigationScreens/DeliveredOrders.dart';
import 'BottomNavigationScreens/NewDelivery.dart';

class DeliveryboyDashboard extends StatefulWidget {
  const DeliveryboyDashboard({Key? key}) : super(key: key);

  @override
  _DeliveryboyDashboardState createState() => _DeliveryboyDashboardState();
}

class _DeliveryboyDashboardState extends State<DeliveryboyDashboard> {
  late DatabaseReference mRef, mDBList;
  late FirebaseAuth _mAuth;
  late String pushKey;

  int _currentIndex = 0;
  static const List<Widget> _widgetOption = <Widget>[
    NewDelivery(),
    DeliveredOrders(),
  ];

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    initVals();
    // setState(() {});
  }

  void getCurrentLocation() async {
    var position = await Location.instance.getLocation();
    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // DatabaseReference mUref = FirebaseDatabase.instance.reference();
    // mUref.child("Delivery Boy").child(_mAuth.currentUser!.uid);
    //
    // mUref.once().then((DataSnapshot snapshot) {
    //   pushKey = snapshot.value["pushKey"];
    //   Fluttertoast.showToast(msg: pushKey);
    // });

    DatabaseReference muserRef = FirebaseDatabase.instance.reference();
    muserRef.child("Delivery Boy").child(FirebaseAuth.instance.currentUser!.uid).once().then((DataSnapshot snapShot) {
      pushKey = snapShot.value["pushKey"];
      Fluttertoast.showToast(msg: pushKey);
      String latitudeCord = position.latitude.toString();
      String longitudeCord = position.longitude.toString();

      Fluttertoast.showToast(msg: latitudeCord + "," + longitudeCord);

      HashMap<String, Object> updateMap = HashMap();
      updateMap["latitude"] = latitudeCord;
      updateMap["longitude"] = longitudeCord;

      mDBList.child("DB List").child(pushKey).update(updateMap).then((value) {
        mRef.child("Delivery Boy").child(_mAuth.currentUser!.uid).update(updateMap);
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FirebaseAuth.instance.signOut();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: _widgetOption.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepOrange,
          selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining), label: "New Delivery", backgroundColor: Colors.deepOrange),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_transportation), label: "Delivered Order", backgroundColor: Colors.deepOrange),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  void initVals() {
    mRef = FirebaseDatabase.instance.reference();
    mDBList = FirebaseDatabase.instance.reference();
    _mAuth = FirebaseAuth.instance;
  }

  void updateLocation() {}
}
