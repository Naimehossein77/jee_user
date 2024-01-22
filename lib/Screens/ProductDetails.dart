import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Screens/OrderNow.dart';
import 'package:jee_user/Widgets/ProgressDialog.dart';

class ProductDetails extends StatefulWidget {
  String imageURl, name, price, category, discount, productDesc, deliveryTime, productID;

  ProductDetails(
      {required this.imageURl,
      required this.name,
      required this.price,
      required this.category,
      required this.discount,
      required this.productDesc,
      required this.deliveryTime,
      required this.productID});

  @override
  _ProductDetailsState createState() =>
      _ProductDetailsState(imageURl, name, price, category, discount, productDesc, deliveryTime, productID);
}

class _ProductDetailsState extends State<ProductDetails> {
  String imageURl, name, price, category, discount, productDesc, deliveryTime, productID;

  _ProductDetailsState(this.imageURl, this.name, this.price, this.category, this.discount, this.productDesc,
      this.deliveryTime, this.productID);

  DatabaseReference mFavrioutRef = FirebaseDatabase.instance.reference();
  FirebaseAuth _mAuth = FirebaseAuth.instance;

  DatabaseReference mUserRef = FirebaseDatabase.instance.reference();
  DatabaseReference mHotelRef = FirebaseDatabase.instance.reference();

  String userID = "";
  String hotelName = "";
  String totalDiscountedPrice = "";

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   mUserRef
  //       .child("Users Product")
  //       .child(productID)
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     userID = snapshot.value["userID"];
  //   });
  //
  //   mHotelRef.child("Admin").child(userID).once().then((DataSnapshot snapshot) {
  //     hotelName = snapshot.value["restorent_name"];
  //     displayToast(hotelName, context);
  //   });
  //
  //   setState(() {
  //     //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Hero(
              tag: "itemImage",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          height: 300,
                          width: size.width,
                          child: Image.network(
                            imageURl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: size.height * 0.56,
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          margin: EdgeInsets.only(top: size.height * 0.35),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 6.0),
                                )
                              ],
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20.0),
                                  ),
                                  Column(
                                    children: [
                                      isDiscount(),
                                      Text(
                                        discount.isEmpty ? discount : "Discount " + discount,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Description",
                                      style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      productDesc,
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          "Product Category: ",
                                          style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          category,
                                          style: GoogleFonts.poppins(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          "Delivery Time: ",
                                          style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          deliveryTime,
                                          style: GoogleFonts.poppins(fontSize: 16.0),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 40.0),
                              Positioned(
                                child: Container(
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          addToFaviouts();
                                        },
                                        child: Icon(Icons.favorite_outline),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black12,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                      ),
                                      SizedBox(width: 10.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          OrderNow(productID);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.wallet_travel_rounded),
                                            SizedBox(width: 20.0),
                                            Text(
                                              "Order Now",
                                              style: GoogleFonts.poppins(fontSize: 16.0),
                                            )
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.deepOrange,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget isDiscount() {
    if (discount.isEmpty) {
      return Text("PKR " + price, style: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w500));
    } else {
      var _discount = discount;
      var splitList = _discount.split("%");

      var priceinInt = int.parse(price);
      assert(priceinInt is int);

      var _discounted = int.parse(splitList[0]);
      assert(_discounted is int);

      var subPrice = priceinInt - _discounted;

      totalDiscountedPrice = (priceinInt - (priceinInt * _discounted) / 100).toString();

      return Column(
        children: [
          Text("PKR " + price,
              style: GoogleFonts.poppins(
                  fontSize: 18.0, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough)),
          Text("PKR " + totalDiscountedPrice.toString(),
              style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500)),
        ],
      );
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void addToFaviouts() {
    showDialog(context: context, builder: (context) => ProgressDialog("Please Wait..."));

    String currentUserID = _mAuth.currentUser!.uid;
    mFavrioutRef = mFavrioutRef.child("Favorits").child(currentUserID);
    String favoritsID = mFavrioutRef.push().key;

    Map favoritsMap = {
      "itemID": productID,
      "userID": currentUserID,
      "favoritsID": favoritsID,
      "itemNmae": name,
      "itemPrice": price,
      "discount": discount,
      "description": productDesc,
      "deliveryTime": deliveryTime,
      "imageURl": imageURl
    };

    if (_mAuth.currentUser != null) {
      mFavrioutRef.child(favoritsID).set(favoritsMap).then((value) {
        Navigator.pop(context);
        displayToast("Success! Added to favorits", context);
        setState(() {
          Icon(Icons.favorite_sharp);
        });
      }).catchError((err) {
        displayToast(err, context);
      });
    }
  }

  void displayToast(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
//////////////////////////////////////////////////////////
  void OrderNow(String productID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Order(
                  productID: productID,
                  itemName: name,
                  deliveryTime: deliveryTime,
                  discunt: totalDiscountedPrice,
                  price: price,
                  productImage: imageURl,
                )));
  }
}
