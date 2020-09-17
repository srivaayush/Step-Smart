import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etutor/screens/profile/student_form.dart';
import 'package:etutor/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit_profile_student.dart';

String name = '';
String standard = '';
int age = 0;
String gender = '';
String subjects = '';
String address = '';
int phone = 0;
Map arr = {};
String _img = '';
Future<bool> test(doc) async {
  //print("right3");
  _img = '';
  arr = {};
  await Firestore.instance
      .collection('users')
      .document(doc.documentID)
      .get()
      .then((e) {
    arr = e.data['img'];
    if (arr != null) {
      _img = arr['url'];
    }
    name = e.data['name'];
    standard = e.data['standard'];
    age = e.data['age'];
    gender = e.data['gender'];
    subjects = e.data['subjects'];
    address = e.data['address'];
    phone = e.data['phone'];
  });
  if (standard != null) {
    return true;
  } else {
    return test(doc);
  }
}

// ignore: must_be_immutable
class StudentProfile extends StatelessWidget {
  var doc;
  StudentProfile({this.doc});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: test(this.doc),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.data != null && standard != null) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text("My Profile"),
              ),
              body: new ListView(shrinkWrap: true, children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.transparent])),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: CircleAvatar(
                                backgroundImage: (_img != null)
                                    ? NetworkImage(
                                        _img,
                                      )
                                    : Image.asset(
                                        "assets/images/unpic.png",
                                        fit: BoxFit.fill,
                                      ),
                                radius: 95,
                              ),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Class",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        standard,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Age",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        age.toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Gender",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        gender,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "◆ Teachers Required for Subjects :",
                          style: TextStyle(
                              decorationStyle: TextDecorationStyle.wavy,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "     " + subjects,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "◆ Contact Details :",
                          style: TextStyle(
                              decorationStyle: TextDecorationStyle.wavy,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "     " + address,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          "\n     " + phone.toString() + "\n\n",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 40.0),
                            color: Colors.red[200],
                            child: Text(
                              'NOTICE:\n You can contact us to get the demo youtube video of whichever tutor you want!\n 1. Gpay/PhonePe/Paytm at 8924019879 Or (Account no 31180649195, BANK NAME: SBI MMMEC,IFSC SBIN0002578)  Rs 99* to the admin \n2. Send the screenshot of payment to the admin on Whatsapp number ( 8924019879 ) \n3. Admin will approve your request ASAP after which you will be sent the demo video of teacher you wanna get!\n4. Feel free to connect with us at stepsmart999@gmail.com  or at 8924019879 or 8318448908 , in case of any difficulty Happy Learning!',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 60, right: 60, bottom: 100),
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffe6020a),
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditStudentForm(
                                        doc,
                                        name,
                                        phone,
                                        age,
                                        gender,
                                        address,
                                        standard,
                                        subjects);
                                  }));
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Center(
                                  child: Text(
                                    "Edit Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontFamily: 'Montserrat',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                )))))
              ]));
        } else {
          return Loading();
        }
      },
    );
  }
}
