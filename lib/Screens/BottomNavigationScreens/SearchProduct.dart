import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Models/ProductModel.dart';

import '../ProductDetails.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({
    Key? key,
  }) : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  TextEditingController _searchController = TextEditingController();
  List<ProductModel> productList = [];
  DatabaseReference mPRef = FirebaseDatabase.instance.reference().child("Users Product");
  List tempMap = [], result = [];
  @override
  void initState() {
    log('search initState()');
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

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  void mySearchItem(String value) {
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Search Your Cravings", style: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.w600)),
              SizedBox(height: 20.0),
              Container(
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 10.0,
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      // searchMethod(text);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        hintText: "Search Any Food!",
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            mySearchItem(_searchController.text.trim());
                          },
                          child: Material(
                              elevation: 10.0,
                              borderRadius: BorderRadius.circular(50),
                              child: Icon(
                                Icons.search,
                                color: Colors.deepOrange,
                              )),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Flexible(
                child: Container(
                    child: result.length == 0
                        ? Center(
                            child: Text("OOPS! Nothing Found"),
                          )
                        : ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              return SearchUI(
                                result[index]['itemName'],
                                result[index]['deliveryTime'],
                                result[index]['disCount'],
                                result[index]['itemPrice'],
                                result[index]['productImageURl'],
                                result[index]['itemCategory'],
                                result[index]['productDesc'],
                                result[index]['productID'],
                              );
                            })),
              )
            ],
          ),
        ),
      ),
    );
  }

  void searchItem(String text) {
    DatabaseReference mSearchRef = FirebaseDatabase.instance.reference();

    mSearchRef.child("Users Product").once().then((DataSnapshot snapshot) {
      productList.clear();
      var Keys = snapshot.value.keys;
      var values = snapshot.value;

      for (var singleKey in Keys) {
        ProductModel productModel = ProductModel(
            values[singleKey]["deliveryTime"],
            values[singleKey]["disCount"],
            values[singleKey]["isDiscount"],
            values[singleKey]["itemCategory"],
            values[singleKey]["itemName"],
            values[singleKey]["itemPrice"],
            values[singleKey]["productImageURl"],
            values[singleKey]["userID"],
            values[singleKey]["productDesc"],
            values[singleKey]["productID"]);
        if (productModel.itemName.contains(text)) {
          productList.add(productModel);
        }
      }
    });
  }

  Widget SearchUI(String itemName, String deliveryTime, String disCount, String itemPrice, String productImageURl,
      String catagory, String description, String productID) {
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
                                imageURl: productImageURl,
                                name: itemName,
                                price: itemPrice,
                                category: catagory,
                                discount: disCount,
                                productDesc: description,
                                deliveryTime: deliveryTime,
                                productID: productID,
                              )));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    productImageURl,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),
                        ),
                        Row(
                          children: [
                            Text(
                              "PKR" + " " + itemPrice,
                              style:
                                  GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14.0),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "(22 Reviews)",
                              style:
                                  GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.amber, fontSize: 14.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Delivery Time " + deliveryTime,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.amber)),
                        Text(disCount.isEmpty ? disCount : "Discount " + disCount,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void searchMethod(String text) {
    DatabaseReference searchRefrence = FirebaseDatabase.instance.reference().child("Users Product");
    searchRefrence.once().then((DataSnapshot snapshot) {
      productList.clear();

      var keys = snapshot.value.key;
      var values = snapshot.value;

      for (var key in keys) {
        ProductModel productListModel = ProductModel(
            values[key]["deliveryTime"],
            values[key]["disCount"],
            values[key]["isDiscount"],
            values[key]["itemCategory"],
            values[key]["itemName"],
            values[key]["itemPrice"],
            values[key]["productImageURl"],
            values[key]["userID"],
            values[key]["productDesc"],
            values[key]["productID"]);

        if (productListModel.itemName.contains(text)) {
          productList.add(productListModel);
        }
      }
      Timer(Duration(seconds: 1), () {
        setState(() {});
      });
    });
  }
}
