import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Models/FavoritsList.dart';

class FavList extends StatefulWidget {
  const FavList({Key? key}) : super(key: key);

  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  DatabaseReference mFavref = FirebaseDatabase.instance.reference();
  FirebaseAuth _mAuth = FirebaseAuth.instance;
  List<FavoritsList> favlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mFavref
        .child("Favorits")
        .child(_mAuth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      var keys = snapshot.value.key;
      var data = snapshot.value;

      favlist.clear();

      for (var key in keys) {
        FavoritsList favoritsList = FavoritsList(
            data[key]["favoritsID"],
            data[key]["itemID"],
            data[key]["userID"],
            data[key]["discount"],
            data[key]["itemNmae"],
            data[key]["itemPrice"],
            data[key]["description"],
            data[key]["deliveryTime"],
            data[key]["imageURl"]);

        favlist.add(favoritsList);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: favlist.length == 0
            ? Text("No Data Found")
            : ListView.builder(
                itemCount: favlist.length,
                itemBuilder: (BuildContext context, var index) {
                  return FavListUI(
                      favlist[index].itemNmae,
                      favlist[index].imageURl,
                      favlist[index].description,
                      favlist[index].deliveryTime,
                      favlist[index].discount,
                      favlist[index].itemPrice);
                },
              ),
      ),
    );
  }

  void displayToast(String itemID, BuildContext context) {
    Fluttertoast.showToast(msg: itemID);
  }

  Widget FavListUI(String itemNmae, String imageURl, String description,
      String deliveryTime, String discount, String itemPrice) {
    return Container(
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
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
    );
  }
}
