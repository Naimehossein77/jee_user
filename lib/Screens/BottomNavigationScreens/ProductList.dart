import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Screens/BottomNavigationScreens/SearchProduct.dart';

import '../ProductDetails.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DatabaseReference mPRef = FirebaseDatabase.instance.reference().child("Users Product");
  TextEditingController _searchController = TextEditingController();
  List tempMap = [], result = [];
  @override
  void initState() {
    // TODO: implement initState
    mPRef.once().then((value) {
      var temp = Map<String, dynamic>.from(value.value);
      if (temp != null)
        tempMap = temp.entries.map((e) {
          return e.value;
        }).toList();
      print(tempMap);
    });

    super.initState();
  }

  void searchItem(String value) {
    result.cast();
    result = [];
    int length = value.length;
    String subString;
    tempMap.forEach((element) {
      subString = element['itemName'];
      subString = subString.toLowerCase();
      value = value.toLowerCase();
      print(subString);
      if (subString.contains(value)) result.add(element);
    });
    print(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "What would you  \nlike to eat",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 28.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(50.0),
              child: TextFormField(
                // enableInteractiveSelection: false,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search any Food",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      log('clicked');
                    },
                    child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(50.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                ),
                onChanged: (vlaue) {
                  searchItem(vlaue);
                },
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Most Popular ", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18.0)),
                  Text(
                    "View All",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.deepOrange, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Flexible(
                child: (_searchController.text != '')
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: result.length,
                        itemBuilder: (_, index) {
                          return _productListWidget(productMap: result[index]);
                        })
                    : FirebaseAnimatedList(
                        query: mPRef,
                        itemBuilder:
                            (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map productMap = snapshot.value;
                          print(productMap);
                          return _productListWidget(productMap: productMap);
                        },
                      ))
          ],
        ),
      ),
    );
  }

  Widget _productListWidget({required Map productMap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            Hero(
              tag: "itemImage",
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (BuildContext context, Animation<double> animation,
                                  Animation<double> secondaryAnimation) =>
                              ProductDetails(
                                imageURl: productMap["productImageURl"],
                                name: productMap["itemName"],
                                price: productMap["itemPrice"],
                                category: productMap["itemCategory"],
                                discount: productMap["disCount"],
                                productDesc: productMap["productDesc"],
                                deliveryTime: productMap["deliveryTime"],
                                productID: productMap["itemID"],
                              )));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    productMap["productImageURl"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.black12],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              left: 5.0,
              bottom: 5.0,
              right: 5.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productMap["restaurant"],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),
                              ),
                              Text(
                                productMap["itemName"],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "PKR" + " " + productMap["itemPrice"],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    "(22 Reviews)",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500, color: Colors.amber, fontSize: 14.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Delivery Time " + productMap["deliveryTime"],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.amber)),
                              Text(
                                  productMap["disCount"].isEmpty
                                      ? productMap["disCount"]
                                      : "Discount " + productMap["disCount"],
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void startNextActivity(String searchText) {
    Navigator.pushNamed(context, "/SearchProduct", arguments: {searchText});
  }
}
