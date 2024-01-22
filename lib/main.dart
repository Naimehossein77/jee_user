import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Screens/LoginDeliveryBoy.dart';

import 'Screens/DashboardScreen.dart';
import 'Screens/RegisterScreen.dart';
import 'Widgets/ProgressDialog.dart';
import 'package:validators/validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.deepOrangeAccent));

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.deepOrange,
      accentColor: Colors.deepOrangeAccent,
    ),
    home:

        // FirebaseAuth.instance.currentUser == null) ?
        HomeScreen(),
    // :DashboardScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

final DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Users");

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  late bool isEmailerror, isPasswordError;
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
    isEmailerror = isPasswordError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage('assets/images/bg_image.jpg'),
            //     fit: BoxFit.cover)
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "Just Eat and Enjoy",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24.0),
                    ),
                    Text(
                      "TASTE YOUR CHOICE",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            suffixIcon: isEmailerror
                                ? Icon(
                                    Icons.info,
                                    color: Colors.red,
                                  )
                                : null,
                            hintText: "example@example.com",
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: isEmailerror ? Colors.red : Colors.deepOrange, width: 2.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: isEmailerror ? Colors.red : Colors.deepOrange, width: 1.0))),
                        validator: (value) {
                          if (!isEmail(value!) || value == '') {
                            isEmailerror = true;
                            setState(() {});
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (isEmail(value)) {
                            setState(() {
                              isEmailerror = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            suffixIcon: isPasswordError
                                ? Icon(
                                    Icons.info,
                                    color: Colors.red,
                                  )
                                : null,
                            hintText: "Your Password",
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: isPasswordError ? Colors.red : Colors.deepOrange, width: 2.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: isPasswordError ? Colors.red : Colors.deepOrange, width: 1.0))),
                        validator: (value) {
                          if (value!.length < 8) {
                            setState(() {
                              isPasswordError = true;
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.length >= 8) {
                            isPasswordError = false;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        "Login As Deliveryboy",
                        style: GoogleFonts.poppins(
                            fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.orangeAccent),
                      ),
                      onTap: () {
                        navigateTologin();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        if (!isEmail(_emailController.text) && _passwordController.text.length < 8) {
                          isEmailerror = true;
                          isPasswordError = true;
                          displayToast("Valid Email and 8 charecter Passward Required", context);
                        } else if (!isEmail(_emailController.text)) {
                          isEmailerror = true;
                          displayToast("Valid Email Required", context);
                        } else if (_passwordController.text.length < 8) {
                          isPasswordError = true;
                          displayToast("Password must be 8 charecters", context);
                        } else {
                          isEmailerror = isPasswordError = false;
                          userSignin(context);
                        }
                        setState(() {});
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?"),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser()));
                        },
                        child: Text(
                          "Create one.",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.deepOrange),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayToast(String message, BuildContext context) {
    log('toast');
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  FirebaseAuth _mAuth = FirebaseAuth.instance;

  void userSignin(BuildContext context) async {
    showDialog(context: context, builder: (context) => ProgressDialog("Please Wait..."));

    final User? firebaseUser = (await _mAuth
            .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Check Email or password", context);
    }))
        .user;

    userRef.child(firebaseUser!.uid).once().then(((DataSnapshot snap) {
      if (snap.value != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Navigator.pop(context);
        _mAuth.signOut();
      }
    }));
    if (firebaseUser != null) {
    } else {
      Navigator.pop(context);
      displayToast("Error! Login Failed", context);
    }
  }

  void navigateTologin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDelivery()));
  }
}
