import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:etutor/models/user.dart';
import 'package:etutor/screens/profile/update_student.dart';
import 'package:etutor/screens/profile/update_tutor.dart';
import 'package:etutor/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

String _name = '';
String _exp = '';
int _fees = 0;
String _img = " ";
Map _arr = {};
double _rating = 5;
String _gender = '';
int _age = 0;
String _acad = '';
String _subjects = '';
String _institute = '';
String _mode = '';
Icon _favIcon = new Icon(Icons.favorite_border);
Color _buttonColor = Colors.pinkAccent;
String _buttontext = 'Submit info request';
bool rated = false;
bool profilemaked = false;
String error2 = "";
Color rate_clr;
Future<bool> testFut(doc, userdoc) async {
  //print(_favIcon);
  await doc.get().then((value) {
    _arr = value.data['img'];
    if (_arr != null) {
      _img = _arr['url'];
    }
    _name = value.data['name'];
    _exp = value.data['experience'];
    _fees = value.data['fees'];
    _gender = value.data['gender'];
    _age = value.data['age'];
    _acad = value.data['acad'];
    _subjects = value.data['subjects'];
    _mode = value.data['mode'];
    _institute = value.data['institute'];
    _rating = value.data['rating'] / value.data['rateUser'];
  });
  if (_rating >= 4) {
    rate_clr = Colors.green;
  } else if (_rating >= 2) {
    rate_clr = Colors.deepOrange;
  } else if (_rating >= 0) {
    rate_clr = Colors.red;
  }
  await userdoc.get().then((mydoc) {
    if (mydoc.data['name'] != "Unknown") {
      profilemaked = true;
    }
    if (mydoc.data['fav'] != null) {
      for (var uid in mydoc.data['fav']) {
        if (uid == doc.documentID) {
          //print(uid);
          _favIcon = new Icon(
            Icons.favorite,
            color: Colors.red,
          );
          break;
        } else {
          _favIcon = new Icon(Icons.favorite_border);
        }
      }
    }
    if (mydoc.data['req'] != null) {
      for (var uid in mydoc.data['req']) {
        if (uid == doc.documentID) {
          //print(uid);
          _buttonColor = Colors.black38;
          _buttontext = 'Cancel info request';
          break;
        } else {
          _buttonColor = Colors.pinkAccent;
          _buttontext = 'Submit info request';
        }
      }
    }
    if (mydoc.data['rated'] != null) {
      rated = false;
      for (var uid in mydoc.data['rated']) {
        if (uid == doc.documentID) {
          rated = true;
          break;
        }
      }
    }
  });
  if (_gender != null) {
    return true;
  } else {
    return testFut(doc, userdoc);
  }
}

class Profile extends StatefulWidget {
  var doc;
  Profile({this.doc});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _valueRating = "1";
  int rating = 0;
  String error = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var userdoc = Firestore.instance.collection('users').document(user.uid);

    void _favPressed() {
      setState(() {
        if (_favIcon.icon == Icons.favorite_border) {
          _favIcon = new Icon(
            Icons.favorite,
            color: Colors.red,
          );
          Toast.show("Added to favourites", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          List<String> _fav = [widget.doc.documentID];
          userdoc.updateData({
            'fav': FieldValue.arrayUnion(_fav),
          });
        } else {
          _favIcon = Icon(Icons.favorite_border);
          Toast.show("Removed from favourites", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          List<String> _fav = [widget.doc.documentID];
          userdoc.updateData({
            'fav': FieldValue.arrayRemove(_fav),
          });
        }
      });
    }

    void _buttonPressed() {
      setState(() {
        error2 = "";
        if (profilemaked == false) {
          error2 = "Please create an account first";
          return;
        }
        if (_buttonColor == Colors.black38) {
          _buttonColor = Colors.pinkAccent;
          _buttontext = "Submit info request";
          Toast.show("Info Request Cancelled", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          List<String> _req = [widget.doc.documentID];
          userdoc.updateData({
            'req': FieldValue.arrayRemove(_req),
          });
        } else {
          _buttonColor = Colors.black38;
          _buttontext = "Cancel info request";
          Toast.show("Info request Submitted", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          List<String> _req = [widget.doc.documentID];
          userdoc.updateData({
            'req': FieldValue.arrayUnion(_req),
          });
        }
      });
    }

    Widget _buildBar(BuildContext context) {
      return new AppBar(
        centerTitle: true,
        title: Text("Profile"),
        actions: <Widget>[
          new IconButton(
            icon: _favIcon,
            onPressed: _favPressed,
          )
        ],
      );
    }

    //print(widget._name);
    return FutureBuilder(
        future: testFut(widget.doc, userdoc),
        builder: (context, snapshot) {
          if (snapshot.data != null && _gender != null) {
            return Scaffold(
              appBar: _buildBar(context),
              body: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue, Colors.transparent])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
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
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              _name,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 22.0,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Card(
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
                                            "Rating",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(_rating.toStringAsFixed(1),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: rate_clr,
                                                  )),
                                              Image.asset(
                                                "assets/images/star.png",
                                                height: 23,
                                                width: 23,
                                              ),
                                            ],
                                          ))
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
                                          Text(
                                            _age.toString(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xffe6020a),
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
                                          Text(
                                            _gender,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xffe6020a),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Master in Subjects :",
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
                            "    " + _subjects,
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
                          vertical: 15.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Expected Salary :",
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
                            "    ₹" + _fees.toString() + "/subject",
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
                  //-------------------Mode of Teaching----------------
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Mode of Teaching :",
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
                            "     " + _mode,
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
                  //-----------------------Acad------------------------
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Academic Qualifications :",
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
                            "     " + _acad,
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
                  //----------------------Institute---------------------
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Institute :",
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
                            "     " + _institute,
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
                  //----------------------Experience--------------------
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "◆ Teaching Experience :",
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
                            "     " + _exp,
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffe6020a),
                              style: BorderStyle.none,
                              width: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Material(
                              color: _buttonColor,
                              borderRadius: BorderRadius.circular(30),
                              elevation: 14.0,
                              shadowColor: Color(0x802196F3),
                              child: InkWell(
                                  onTap: () {
                                    _buttonPressed();
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Center(
                                    child: Text(
                                      _buttontext,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ))))),
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    child: Text(
                      error2,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 80, right: 80, top: 20),
                    child: Center(
                      child: Text(
                        "RATE THIS TEACHER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(left: 80, right: 80),
                      child: Center(
                        child: RatingBar(
                            // initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            unratedColor: Colors.amber.withAlpha(70),
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (vote) {
                              rating = vote.toInt();
                            }),
                      )),

                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 60, bottom: 0),
                    child: RaisedButton(
                      disabledColor: Colors.grey,
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.pinkAccent,
                      child: Text(
                        'Rate!',
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                      onPressed: () {
                        if (rated == true) {
                          setState(() {
                            error = 'You\'ve already rated';
                          });
                        } else if (rating == 0) {
                          setState(() {
                            error = 'Please Select an option and try again!';
                          });
                        } else if (profilemaked = false) {
                          setState(() {
                            error = "Please create an account first";
                          });
                        } else {
                          dynamic result =
                              UpdateTutor(uid: widget.doc.documentID)
                                  .updateRating(rating);
                          if (result != null) {
                            dynamic result2 =
                                UpdateStudent(uid: widget.doc.documentID)
                                    .updateRatingtoTutor(user.uid);
                            if (result2 != null) {
                              setState(() {
                                rated = true;
                                error = 'Successfully Rated';
                              });
                            } else {
                              setState(() {
                                error = 'Error Occured, Try Again!';
                              });
                            }
                          } else {
                            setState(() {
                              error = 'Error Occured, Try Again!';
                            });
                          }
                          /*------------------------------------------------------------------------*/
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
                    child: Text(
                      error,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                      color: Colors.red[200],
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 40.0),
                      child: Text(
                        'NOTICE:\nFor quicker experience feel free to connect with us at 8924019879 or 8318448908, Happy Learning!',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                  /* Text(
                    error,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900),
                  ), */
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
