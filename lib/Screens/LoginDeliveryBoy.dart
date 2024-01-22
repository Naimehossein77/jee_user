import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jee_user/Screens/DeliveryBoyDashboard.dart';
import 'package:jee_user/Screens/DeliveryboyRegistration.dart';
import 'package:jee_user/Widgets/ProgressDialog.dart';
import 'package:validators/validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.deepOrangeAccent));
}

final DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Delivery Boy");

class LoginDelivery extends StatefulWidget {
  const LoginDelivery({Key? key}) : super(key: key);

  @override
  _LoginDeliveryState createState() => _LoginDeliveryState();
}

class _LoginDeliveryState extends State<LoginDelivery> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late bool isEmailError, isPasswordError;
  void initState() {
    super.initState();
    isEmailError = isPasswordError = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FirebaseAuth.instance.signOut();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(image: AssetImage('assets/images/bg_image.jpg'), fit: BoxFit.cover
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
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            suffixIcon: isEmailError
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
                                    BorderSide(color: isEmailError ? Colors.red : Colors.deepOrange, width: 2.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: isEmailError ? Colors.red : Colors.deepOrange, width: 1.0))),
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
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Text(
                      //   "Forgot Password?",
                      //   style: GoogleFonts.poppins(
                      //       fontSize: 14.0, fontWeight: FontWeight.w300),
                      // ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          if (isEmail(_emailController.text) && _passwordController.text.length >= 8) {
                            isEmailError = isPasswordError = false;
                            userSignin(context);
                          }
                          if (!isEmail(_emailController.text)) {
                            isEmailError = true;
                            displayToast("Email Required", context);
                          } else
                            isEmailError = false;
                          if (_passwordController.text.length < 8) {
                            isPasswordError = true;
                            displayToast("Password Required", context);
                          } else
                            isPasswordError = false;
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryboyRegistraiton()));
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
      ),
    );
  }

  void displayToast(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
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
      print(firebaseUser.uid);
      print(snap.value);
      if (snap.exists) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryboyDashboard()));
      } else {
        Navigator.pop(context);
        _mAuth.signOut();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryboyDashboard()));
      }
    }));
    if (firebaseUser != null) {
    } else {
      Navigator.pop(context);
      displayToast("Error! Login Failed", context);
    }
  }
}
