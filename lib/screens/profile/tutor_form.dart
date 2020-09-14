import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:etutor/main.dart';
import 'package:etutor/screens/profile/tutor_profile.dart';
import 'package:etutor/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:etutor/models/user.dart';
import 'package:etutor/screens/profile/update_tutor.dart';
// ignore: unused_import
import 'package:etutor/screens/home/home.dart';

// ignore: must_be_immutable
class TutorForm extends StatefulWidget {
  var doc;

  String name = '';
  int phone = 0;
  int age = 0;
  String gender = '';
  String address = '';
  String acad = '';
  String subjects = '';
  String exp = '';
  String error = '';
  String institute = '';
  String mode = '';
  String city = '';
  String yt = '';
  int fees = 0;
  //options
  String _valueGender = "Male";
  String _valueMode = "Online";
  //image portion
  File _image;
  TutorForm({this.doc});
  @override
  TutorFormState createState() {
    return TutorFormState();
  }
}

String alert = "";

class TutorFormState extends State<TutorForm> {
  final _formKey = GlobalKey<FormState>();
  //text field state
  // String name = '';
  // int phone = 0;
  // int age = 0;
  // String gender = '';
  // String address = '';
  // String acad = '';
  // String subjects = '';
  // String exp = 'NAN';
  // String error = '';
  // String institute = 'NAN';
  // String mode = '';
  // String city = '';
  // String yt = 'NAN';
  // int fees = 0;
  // //options
  // String _valueGender = "Male";
  // String _valueMode = "Online";
  // //image portion
  // File _image;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Future getImage() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      int size = await image.length();
      if (size < 1000000) {
        image = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
        setState(() {
          widget._image = image;
          //print('Image Path $_image');
        });
      } else {
        setState(() {
          alert = "Image size should be less than 1 mb";
          //print('Image Path $_image');
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Tutor Form"),
      ),
      body: Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.black87,
                    child: ClipOval(
                      child: new SizedBox(
                          width: 155.0,
                          height: 155.0,
                          child: (widget._image != null)
                              ? Image.file(
                                  widget._image,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  "assets/images/unpic.png",
                                  fit: BoxFit.fill,
                                )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 30.0,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            Text(
              alert,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xffe6020a),
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue: widget.name,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter your full name',
                labelText: 'Name*',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length > 200) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.name = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.phone.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                labelText: 'Phone*',
              ),
              validator: (value) {
                if (value.isEmpty || value.length != 10) {
                  return 'Please enter valid phone number';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.phone = int.parse(value);
                });
              },
            ),
            TextFormField(
              initialValue: widget.age.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Enter your age :',
                labelText: 'Age*',
              ),
              validator: (value) {
                if (value.isEmpty || value.length != 2) {
                  return 'Please enter valid Age';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.age = int.parse(value);
                });
              },
            ),
            TextFormField(
              initialValue: widget.address,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.account_balance),
                hintText: 'Enter your address',
                labelText: 'Address*',
              ),
              validator: (value) {
                if (value.isEmpty || value.length > 2000) {
                  return 'Please enter valid address';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.address = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.city,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.account_balance),
                hintText: 'Enter your city/landmark',
                labelText: 'City*',
              ),
              validator: (value) {
                if (value.isEmpty || value.length > 15) {
                  return 'Please enter valid address';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.city = value;
                });
              },
            ),
            DropDownFormField(
              titleText: "Gender*",
              hintText: "Gender",
              value: widget._valueGender,
              onSaved: (value) {
                setState(() {
                  widget._valueGender = value;
                  widget.gender = widget._valueGender;
                });
              },
              onChanged: (value) {
                setState(() {
                  widget._valueGender = value;
                  widget.gender = widget._valueGender;
                });
              },
              dataSource: [
                {
                  "display": "Male",
                  "value": "Male",
                },
                {
                  "display": "Female",
                  "value": "Female",
                },
                {
                  "display": "Other",
                  "value": "Other",
                },
              ],
              textField: 'display',
              valueField: 'value',
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            DropDownFormField(
              titleText: "Mode of Teaching*",
              hintText: "Mode of  Teaching",
              value: widget._valueMode,
              onSaved: (value) {
                setState(() {
                  widget._valueMode = value;
                  widget.mode = widget._valueMode;
                });
              },
              onChanged: (value) {
                setState(() {
                  widget._valueMode = value;
                  widget.mode = widget._valueMode;
                });
              },
              dataSource: [
                {
                  "display": "Online",
                  "value": "Online",
                },
                {
                  "display": "Offline",
                  "value": "Offline",
                },
                {
                  "display": "Both(Online and Offline)",
                  "value": "Both(Online and Offline)",
                },
              ],
              textField: 'display',
              valueField: 'value',
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.subjects,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.book),
                hintText: 'Enter the subject(s) which you want to teach',
                labelText: 'The subject(s) which you want to teach',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid subjects';
                }
                if (value.length > 50) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.subjects = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.fees.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: const Icon(Icons.attach_money),
                hintText: 'Enter the your fees/subject',
                labelText: 'The fees/subject expected',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid Fees';
                }
                if (value.length > 6 || value.length < 1) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.fees = int.parse(value);
                });
              },
            ),
            TextFormField(
              initialValue: widget.acad,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Enter your Academic Qualifications',
                labelText: 'Academic Qualifications*',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid Academic Qualifications';
                }
                if (value.length > 100) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.acad = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.institute,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.chrome_reader_mode),
                hintText: 'Enter your Institute',
                labelText: 'Institute',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid Institute';
                }
                if (value.length > 500) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty)
                    widget.institute = 'NA';
                  else
                    widget.institute = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.exp,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.assignment_ind),
                hintText: 'Enter your Earlier Teaching Experiences',
                labelText: 'Earlier Teaching Experiences',
              ),
              validator: (value) {
                if (value.length > 100) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty)
                    widget.exp = 'NA';
                  else
                    widget.exp = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.yt,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: const Icon(Icons.assignment_ind),
                hintText:
                    'Warning :Your video will not be shown to students if you tell your comtact details to them in the video!',
                labelText: 'Enter your Youtube video demo link',
              ),
              validator: (value) {
                if (value.length > 40) {
                  return 'Limit Exceeded';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty)
                    widget.yt = 'NA';
                  else
                    widget.yt = value;
                });
              },
            ),
            new Container(
                padding:
                    const EdgeInsets.only(left: 110.0, right: 130.0, top: 40.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (widget._image == null) {
                      setState(() {
                        widget.error = "Please upload the image!";
                      });
                    } else if (_formKey.currentState.validate() &&
                        widget._image != null) {
                      dynamic result = UpdateTutor(uid: user.uid)
                          .updateTutorDetails(
                              widget._image,
                              widget.name,
                              widget.phone,
                              widget.age,
                              widget.address,
                              widget.city,
                              widget.gender,
                              widget.subjects,
                              widget.fees,
                              widget.acad,
                              widget.exp,
                              widget.mode,
                              widget.institute,
                              widget.yt);
                      if (result != null) {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Wrapper()));
                      } else {
                        setState(() {
                          widget.error = "Error in Details";
                        });
                      }
                    }
                  },
                )),
            SizedBox(height: 12.0),
            Text(
              widget.error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
