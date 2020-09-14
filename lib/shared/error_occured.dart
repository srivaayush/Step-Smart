import 'package:etutor/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class ErrorOccured extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Please Wait",
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return Authenticate();
              }));
            }),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
          child: Text(
            "Please wait for a while, \n If this page doesn't change automatically \n Then there must be some problem. \n\n\n\n Problem can occur from your internet (slow connection) or \n Your email has not been found.",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
