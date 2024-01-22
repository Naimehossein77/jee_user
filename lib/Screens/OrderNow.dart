import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jee_user/Screens/DashboardScreen.dart';
import 'package:jee_user/Screens/selectLocationPage.dart';
import 'package:jee_user/Widgets/ProgressDialog.dart';
import 'package:location/location.dart';

class Order extends StatefulWidget {
  String productID, itemName, deliveryTime, discunt, price, productImage;

  Order(
      {required this.productID,
      required this.itemName,
      required this.deliveryTime,
      required this.discunt,
      required this.price,
      required this.productImage});

  @override
  _OrderState createState() => _OrderState(
      productID: productID,
      itemName: itemName,
      deliveryTime: deliveryTime,
      discunt: discunt,
      price: price,
      productImage: productImage);
}

class _OrderState extends State<Order> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String productID, itemName, deliveryTime, discunt, price, productImage;
  var _formKey = GlobalKey<FormState>();
  String latitudeCord = "";
  String longitudeCord = "";

  var position;
  late LatLng temp;

  _OrderState(
      {required this.productID,
      required this.itemName,
      required this.deliveryTime,
      required this.discunt,
      required this.price,
      required this.productImage});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();

    // setState(() {});
  }

  getCurrentLocation() async {
    position = await Location.instance.getLocation();

    //  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeCord = position.latitude.toString();
      longitudeCord = position.longitude.toString();
    });
    temp = LatLng(double.parse(latitudeCord), double.parse(longitudeCord));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Order"),
        elevation: 0.0,
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PLACE YOUR ORDER",
                      style: GoogleFonts.poppins(letterSpacing: 0.2, fontSize: 22.0, fontWeight: FontWeight.w600)),
                  Text(
                    "Fill The Delivery Details",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 20.0),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Item Name", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: Text(itemName),
                        ),
                        Text("Delivery Time", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: Text(deliveryTime),
                        ),
                        Text("Discount Price", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: Text(discunt),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Address", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600)),
                            ButtonTheme(
                              buttonColor: Colors.deepOrange,
                              splashColor: Colors.deepOrange,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10)),
                                  foregroundColor: MaterialStateProperty.all(Colors.deepOrange),
                                ),
                                onPressed: () async {
                                  await getCurrentLocation();

                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SelectLocationPage(
                                              position: LatLng(position.latitude, position.longitude),
                                              changePosition: (value) {
                                                temp = value;
                                              })));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text('Add Location'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                // suffix: IconButton(
                                //   splashRadius: 10,
                                //   padding: EdgeInsets.zero,
                                //   icon: Icon(Icons.location_city),
                                //   onPressed: () {},
                                // ),
                                border: InputBorder.none,
                                hintText: "Street AO4 Comertical Market"),
                            validator: (value) {
                              if (value == '') {
                                return 'Please enter or Select location';
                              }
                            },
                          ),
                        ),
                        Text("Phone Number", style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(color: Colors.black12),
                          child: TextFormField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(border: InputBorder.none, hintText: "+92341 5272328"),
                            validator: (value) {
                              if (value!.length < 11) {
                                return 'Phone no must be 11 digits';
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              discunt.isEmpty
                                  ? Text("PKR: $price",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.w700))
                                  : Text("PKR: $discunt",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print(temp);
                            if (_formKey.currentState!.validate()) placeOrder();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Confirm Order",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white)),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: [
                                  BoxShadow(color: Colors.deepOrange, blurRadius: 6.0, offset: Offset(0.0, 3.0))
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void placeOrder() {
    showDialog(context: context, builder: (context) => ProgressDialog("Please Wait..."));
    DatabaseReference mOrderRef = FirebaseDatabase.instance.reference();
    DatabaseReference placeOrdeRef = FirebaseDatabase.instance.reference();
    String orderKey = placeOrdeRef.push().key;
    String adminID = "";
    mOrderRef.child("Users Product").child(productID).once().then((DataSnapshot snapshot) {
      adminID = snapshot.value["userID"];

      Map orderMap = {
        "itemName": itemName,
        "itemPrice": price,
        "itemID": productID,
        "userID": adminID,
        "imageUrl": productImage,
        "address": addressController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "latitude": temp.latitude.toString(),
        "longitude": temp.longitude.toString(),
        "orderID": orderKey
      };
      print(adminID);
      placeOrdeRef.child("Order").child(adminID).child(orderKey).set(orderMap).then((result) {
        Fluttertoast.showToast(msg: "Your order have been Placed");
        Navigator.pop(context);
        pushBack();
      }).catchError((err) {
        print(err);
        Fluttertoast.showToast(msg: "Failed! Try Again unexpected error");
        Navigator.pop(context);
        displayToast(context, "Delivery Assigned!");
      });
    });
  }

  void pushBack() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      });
    });
  }

  void displayToast(BuildContext context, String message) {
    Fluttertoast.showToast(msg: message);
  }
}
