import 'package:flutter/material.dart';

class AdminApproval extends StatelessWidget {
  var doc;
  AdminApproval({this.doc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          //backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text('Request to be a teacher'),
        ),
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Text(
                  'Since, We can not allow fake teachers,we have set up admin approval!!!',
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Image.asset(
                "assets/images/fake.jpg",
                height: 200.0,
                width: 200.0,
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Text(
                  '\nAll you need to do is follow the following given steps :',
                  style: TextStyle(
                      fontSize: 21.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text(
                  '1. Gpay/phone pay/paytm at 8924019879 Or (Account no 31180649195, BANK NAME. SBI MMMEC,IFSC SBIN0002578)  99 amount to the admin \n2. Send the screenshot of payment to the admin on Whatsapp number ( 8924019879 ) \n3. Admin will approve your request ASAP after which you can fill the form and upload it on the app!\n4. Feel free to connect with us at stepsmart999@gmail.com  or at 8924019879,in case of any difficulty Happy Learning!',
                  style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ));
  }
}
