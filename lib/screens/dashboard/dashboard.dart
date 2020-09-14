import 'dart:async';
import 'package:etutor/screens/authenticate/authenticate.dart';
import 'package:etutor/shared/email_verification.dart';
import 'package:etutor/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:etutor/services/auth.dart';
import 'package:etutor/screens/dashboard/dashboard_buttons.dart';
import 'package:etutor/screens/wrapper.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  final AuthService _auth = AuthService();
  var doc;
  Dashboard({this.doc});
  bool status;
  @override
  Widget build(BuildContext context) {
    String _occupation = '';
    int _flag = 0;
    int _adminApproval = 0;
    Future userStatus() async {
      status = false;
      await FirebaseAuth.instance.currentUser()
        ..reload();
      var userr = await FirebaseAuth.instance.currentUser();
      if (userr.isEmailVerified) {
        status = true;
        return true;
      }
      return false;
    }

    Future fieldsManagement() async{
      doc.snapshots().listen((value)async{
        if(!value.data.containsKey("flag") && !value.data.containsKey("occupation") && !value.data.containsKey("admin_approval")){
          await doc.setData({
            'name': "Unknown",
            'occupation': "student",
            'city': "",
            'flag': 0,
            'fav': [],
            'req': [],
            'admin_approval': 0,
          });
        }
        else print("Fields exist");
      });
    }

    Future valuess() async {
      await doc.get().then((value) {
        //if(value.data.containskey("admin_approval") && value.data.containskey("occupation") && value.data.containskey("admin_approval")){print("keys not found");}
        _occupation = value.data['occupation'];
//        print("Occupation = "+_occupation);
        _flag = value.data['flag'];
//        print("Flag = "+_flag.toString());
        _adminApproval = value.data['admin_approval'];
//        print("Admin Approval = "+_adminApproval.toString());
      });
      return true;
    }

    return FutureBuilder(
      future: userStatus(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (status != true) {
            return EmailVerfication(doc: doc);
          } else {
            fieldsManagement();
            return FutureBuilder(
              future: valuess(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            "assets/images/logo11.png",
                            colorBlendMode: BlendMode.difference,
                          )),
                      title: Text("Step Smart"),
                      backgroundColor: Colors.blue,
                      actions: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.person),
                          label: Text(
                            'Log out',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await _auth.googleSignOut();
                            return Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Wrapper();
                            }));
                          },
                        )
                      ],
                    ),
                    backgroundColor: Colors.blue[50],
                    body: Center(
                        child: Container(
                            child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 25, bottom: 25),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: <Widget>[
                        DashboardButton("Search", "assets/images/search.png",
                            doc, _adminApproval, _occupation, _flag),
                        DashboardButton("Requests", "assets/images/tick.png",
                            doc, _adminApproval, _occupation, _flag),
                        DashboardButton(
                            "Saved",
                            "assets/images/heartfilled.png",
                            doc,
                            _adminApproval,
                            _occupation,
                            _flag),
                        DashboardButton("Profile", "assets/images/user.png",
                            doc, _adminApproval, _occupation, _flag),
                        DashboardButton("Faq", "assets/images/question_boy.png",
                            doc, _adminApproval, _occupation, _flag),
                        DashboardButton(
                            "PrivacyPolicy",
                            "assets/images/web-development.png",
                            doc,
                            _adminApproval,
                            _occupation,
                            _flag),
                      ],
                    ))),
                  );
                } else {
                  return Loading();
                }
              },
            );
          }
        } else {
          return Loading();
        }
      },
    );
  }
}
