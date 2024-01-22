import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Screens/deliveryDetails.dart';

class NewDelivery extends StatefulWidget {
  const NewDelivery({Key? key}) : super(key: key);

  @override
  _NewDeliveryState createState() => _NewDeliveryState();
}

class _NewDeliveryState extends State<NewDelivery> {
  late DatabaseReference mRef;
  late FirebaseAuth _mAuth;
  late DatabaseReference ref, mDBList;
  late String pushKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mRef = FirebaseDatabase.instance.reference();
    _mAuth = FirebaseAuth.instance;

    ref = FirebaseDatabase.instance.reference();
    mDBList = FirebaseDatabase.instance.reference();
    _mAuth = FirebaseAuth.instance;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("To Deliver", style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w700)),
              Flexible(
                  child: FirebaseAnimatedList(
                query: mRef.child("To Delvier").child(_mAuth.currentUser!.uid),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  Map deliveryMap = snapshot.value;
                  if (!snapshot.exists) {
                    return Center(child: Text("oops! No delivery Assigned to you yet."));
                  } else {
                    return DeliveryUI(deliveryMap: deliveryMap);
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget DeliveryUI({required Map deliveryMap}) {
    return GestureDetector(
        onTap: () {
          log(deliveryMap.toString());
          deliverOrder(deliveryMap["orderID"], deliveryMap["deliveryID"], deliveryMap["restorentID"]);
        },
        child: Material(
          elevation: 2.0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Congratulations",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.0),
                Text("New Delivery Assign to you")
              ],
            ),
          ),
        ));
  }

  void deliverOrder(orderID, deliveryID, restorentID) {
    DatabaseReference mRef = FirebaseDatabase.instance.reference();
    String itemName, itemPrice, lat, lang, address, phoneNumber;
    mRef.child("Order").child(restorentID).child(orderID).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        itemName = snapshot.value["itemName"];
        itemPrice = snapshot.value["itemPrice"];
        lat = snapshot.value["latitude"];
        lang = snapshot.value["longitude"];
        address = snapshot.value["address"];
        phoneNumber = snapshot.value["phoneNumber"];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => deliveryDetails(
                    orderID: orderID,
                    restorentID: restorentID,
                    deliveryID: deliveryID,
                    itemName: itemName,
                    itemPrice: itemPrice,
                    address: address,
                    phone: phoneNumber,
                    lat: lat,
                    lang: lang)));
      }
    });
  }
}
