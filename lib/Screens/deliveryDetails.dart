import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jee_user/Screens/GoogleMapScreen.dart';
import 'package:jee_user/Screens/getDirectionForDeliveryBoy.dart';
import 'package:location/location.dart';

class deliveryDetails extends StatefulWidget {
  // const deliveryDetails({Key? key}) : super(key: key);
  String orderID, restorentID, deliveryID, itemName, itemPrice, address, phone, lat, lang;

  deliveryDetails(
      {required this.orderID,
      required this.restorentID,
      required this.deliveryID,
      required this.itemName,
      required this.itemPrice,
      required this.address,
      required this.phone,
      required this.lat,
      required this.lang});

  @override
  _deliveryDetailsState createState() => _deliveryDetailsState(
      orderID: orderID,
      restorentID: restorentID,
      deliveryID: deliveryID,
      itemName: itemName,
      itemPrice: itemPrice,
      address: address,
      phone: phone,
      lat: lat,
      lang: lang);
}

class _deliveryDetailsState extends State<deliveryDetails> {
  String orderID, restorentID, deliveryID, itemName, itemPrice, address, phone, lat, lang;

  _deliveryDetailsState(
      {required this.orderID,
      required this.restorentID,
      required this.deliveryID,
      required this.itemName,
      required this.itemPrice,
      required this.address,
      required this.phone,
      required this.lat,
      required this.lang});

  late DatabaseReference mRestorentRef, orderRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // setState(() {});
  }

  getCurrentLocation() async {
    var pos = await Location.instance.getLocation();

    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {});
    return pos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: SafeArea(child: ValueChils()),
    );
  }

  Widget ValueChils() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text("Item Name: $itemName", style: GoogleFonts.poppins(fontSize: 18.0)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text("Item Price: $itemPrice", style: GoogleFonts.poppins(fontSize: 18.0)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text("Address: $address", style: GoogleFonts.poppins(fontSize: 18.0)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text("Phone: $phone", style: GoogleFonts.poppins(fontSize: 18.0)),
          ),
          Container(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  Text("LatLang: $lat+$lang", style: GoogleFonts.poppins(color: Colors.white)),
                  GestureDetector(
                    onTap: () {
                      // var position = await getCurrentLocation();
                      LatLng temp = LatLng(double.parse(lat), double.parse(lang));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GetDirection(
                                    position: temp,
                                  )));
                    },
                    child: Text("Click Me to Open Google map",
                        style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
