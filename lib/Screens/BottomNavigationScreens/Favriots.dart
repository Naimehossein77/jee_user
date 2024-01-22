import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Models/FavoritsList.dart';

class FavriotsList extends StatefulWidget {
  const FavriotsList({Key? key}) : super(key: key);

  @override
  _FavriotsListState createState() => _FavriotsListState();
}

class _FavriotsListState extends State<FavriotsList> {
  late List<FavoritsList> favoritsList;
  late FirebaseAuth _mAuth = FirebaseAuth.instance;

  late DatabaseReference mFavoritsRef = FirebaseDatabase.instance
      .reference()
      .child("Favorits")
      .child(_mAuth.currentUser!.uid);
  late String currentUserId;

  late String imageURl = "",
      itemNmae = " ",
      description = "",
      deliveryTime = "",
      itemID = "",
      discount = "",
      itemPrice = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Favorits List",
                  style: GoogleFonts.poppins(
                      fontSize: 18.0, fontWeight: FontWeight.w700)),
              Flexible(
                child: FirebaseAnimatedList(
                  query: mFavoritsRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map favortisMap = snapshot.value;
                    var itemID = favortisMap['itemID'];
                    return FavoritsListUI(favoritsMap: favortisMap);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget FavoritsListUI({required Map favoritsMap}) {
    imageURl = favoritsMap["imageURl"];
    itemNmae = favoritsMap["itemNmae"];
    itemPrice = favoritsMap["itemPrice"];
    deliveryTime = favoritsMap["deliveryTime"];
    discount = favoritsMap["discount"];
    description = favoritsMap["description"];

    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(1.0, 3.0))
            ]),
        child: Row(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: imageURl.isEmpty
                    ? Image.network(
                        "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640",
                        fit: BoxFit.cover,
                        width: 85.0,
                        height: 85.0)
                    : Image.network(
                        imageURl,
                        fit: BoxFit.cover,
                        height: 85.0,
                        width: 85.0,
                      ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            itemNmae,
                            style: GoogleFonts.poppins(
                                fontSize: 16.0, fontWeight: FontWeight.w700),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      children: [
                        Text(
                          "Delivery Time : $deliveryTime",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 5.0),
                        discount.isEmpty
                            ? Text(discount)
                            : Text(
                                "Discount : $discount",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        right: 0.0,
        bottom: 10.0,
        child: GestureDetector(
          onTap: () {
            removeItem(favoritsMap["favoritsID"]);
          },
          child: Container(
            width: 30.0,
            height: 30.0,
            child: Center(
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.redAccent,
                      blurRadius: 6.0,
                      offset: Offset(-2.0, 0.0))
                ],
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(10.0))),
          ),
        ),
      )
    ]);
  }

  void removeItem(String itemID) {
    DatabaseReference removeRef = FirebaseDatabase.instance.reference();

    removeRef
        .child("Favorits")
        .child(_mAuth.currentUser!.uid)
        .child(itemID)
        .remove()
        .then((result) {
      Fluttertoast.showToast(msg: "Removed From Favorits");
    });
  }

  void displayToast(String itemID) {}
}
