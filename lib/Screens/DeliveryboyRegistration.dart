import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Widgets/ProgressDialog.dart';
import 'package:validators/validators.dart';

import '../main.dart';

class DeliveryboyRegistraiton extends StatefulWidget {
  const DeliveryboyRegistraiton({Key? key}) : super(key: key);

  @override
  _DeliveryboyRegistraitonState createState() => _DeliveryboyRegistraitonState();
}

class _DeliveryboyRegistraitonState extends State<DeliveryboyRegistraiton> {
  // Creating controllers to the Textinput fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPassController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  late bool isNameError, isEmailError, isPasswordError, isPhoneError, isAddressError;
  DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Delivery Boy");
  void initState() {
    super.initState();
    isNameError = isEmailError = isPasswordError = isPhoneError = isAddressError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      Text("Just Eat and Enjoy",
                          style: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.black)),
                      Text(
                        "CREATE YOUR DELIVERY BOY ACCOUNT",
                        style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 1.0),
                      )
                    ],
                  )),

              //
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          suffixIcon: isNameError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "Johan Smith",
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),

                    //
                    SizedBox(height: 20.0),

                    //
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          suffixIcon: isEmailError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "example@example.com",
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),

                    //
                    SizedBox(height: 20.0),

                    //
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: isPasswordError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "Your Password",
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),

                    //
                    SizedBox(height: 20.0),

                    //
                    TextFormField(
                      controller: _cPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: isPasswordError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "Confirm Your Password",
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),

                    //
                    SizedBox(height: 20.0),

                    //
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          suffixIcon: isPhoneError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "0341 5272328",
                          labelText: "Phone",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),
                    SizedBox(height: 20.0),
                    //
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          suffixIcon: isAddressError ? Icon(Icons.info, color: Colors.red) : null,
                          hintText: "e.g Street No, House No",
                          labelText: "Address",
                          labelStyle: TextStyle(color: Colors.orange),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.deepOrange, width: 1.0))),
                    ),

                    //
                    SizedBox(height: 20.0),

                    // Register Button
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.length < 4) {
                          isNameError = true;
                          displayToast("Please Enter valid name", context);
                        } else
                          isNameError = false;
                        if (!isEmail(_emailController.text)) {
                          isEmailError = true;
                          displayToast("Enter valid email address", context);
                        } else
                          isEmailError = false;
                        if (_phoneController.text.length < 11) {
                          isPhoneError = true;
                          displayToast("Enter Phone Numnber", context);
                        } else
                          isPhoneError = false;
                        if (_passwordController.text.length < 8) {
                          isPasswordError = true;
                          displayToast("Password must be 8 characters long", context);
                        } else
                          isPasswordError = false;
                        if (_addressController.text.isEmpty) {
                          isAddressError = true;
                          displayToast("Enter Restorent Name", context);
                        } else {
                          isAddressError = false;
                        }
                        if (_nameController.text.length >= 4 &&
                            isEmail(_emailController.text) &&
                            _phoneController.text.length >= 11 &&
                            _passwordController.text.length >= 8 &&
                            !_addressController.text.isEmpty) {
                          registerUser(context);
                          isNameError = isEmailError = isPhoneError = isPasswordError = isAddressError = false;
                        }
                        setState(() {});
                      },
                      child: Text("Create Account"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0)),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Already have account?"),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              },
                              child: Text("Login", style: GoogleFonts.poppins(color: Colors.deepOrange)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text("Register As"),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              },
                              child: Text("Delivery Boy", style: GoogleFonts.poppins(color: Colors.deepOrange)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _mAuth = FirebaseAuth.instance;

  void registerUser(BuildContext context) async {
    showDialog(context: context, builder: (context) => ProgressDialog("Please Wait..."));
    final User? firebaseUser = (await _mAuth
            .createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Error! Check your email or password", context);
    }))
        .user;

    if (firebaseUser != null) {
      String pushKey = userRef.push().key;
      Map userDataMap = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "restorent_name": _addressController.text.trim(),
        "currentLocation": "null",
        "latitude": "null",
        "longitude": "null",
        "pushKey": pushKey,
        "userID": firebaseUser.uid
      };

      DatabaseReference mDBpublicRef = FirebaseDatabase.instance.reference();

      userRef.child(firebaseUser.uid).set(userDataMap);
      mDBpublicRef.child("DB List").child(pushKey).set(userDataMap);

      displayToast("Account Created", context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pop(context);
      displayToast("Account created successfully", context);
    }
  }

  void displayToast(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
