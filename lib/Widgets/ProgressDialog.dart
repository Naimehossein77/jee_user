import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressDialog extends StatelessWidget {
  String message;

  ProgressDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(20.0),
        width: double.infinity,
        // decoration: BoxDecoration(
        //   color: Colors.deepOrange,
        //   borderRadius: BorderRadius.circular(6.0),
        // ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 5.0),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
              SizedBox(width: 10.0),
              Text(
                message,
                style: GoogleFonts.poppins(fontSize: 16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
