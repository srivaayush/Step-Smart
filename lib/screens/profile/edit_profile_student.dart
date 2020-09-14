import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:etutor/screens/profile/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:etutor/models/user.dart';
import 'package:etutor/screens/profile/update_student.dart';
import 'package:toast/toast.dart';

class EditStudentForm extends StatefulWidget {
  var doc;
  //text field state
  String name = '';
  int phone = 0;
  int age = 0;
  String gender = '';
  String address = '';
  String standard = '';
  String subjects = '';
  String error = '';
  //options
  String _valueGender = "Male";
  //image portion
  File _image;
  EditStudentForm(this.doc, this.name, this.phone, this.age, this.gender,
      this.address, this.standard, this.subjects);
  @override
  EditStudentFormState createState() {
    return EditStudentFormState();
  }
}

String alert = "";

class EditStudentFormState extends State<EditStudentForm> {
  final _formKey = GlobalKey<FormState>();
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
        title: Text("Student Form"),
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
                labelText: 'Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length > 25) {
                  return 'Name too long';
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
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                labelText: 'Phone',
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
                labelText: 'Age',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid age';
                }
                if (age < 1 || age > 150) {
                  return 'Please enter valid age';
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
                labelText: 'Address',
              ),
              validator: (value) {
                if (value.isEmpty || value.length > 1000) {
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
            DropDownFormField(
              titleText: "Gender",
              hintText: "Gender",
              value: widget._valueGender,
              onSaved: (value) {
                setState(() {
                  widget._valueGender = value;
                  gender = widget._valueGender;
                });
              },
              onChanged: (value) {
                setState(() {
                  widget._valueGender = value;
                  gender = widget._valueGender;
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
            TextFormField(
              initialValue: widget.standard,
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Enter your  Class',
                labelText: 'Class ',
              ),
              validator: (value) {
                if (value.isEmpty || value.length > 100) {
                  return 'Please enter valid Class';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.standard = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.subjects,
              decoration: const InputDecoration(
                icon: const Icon(Icons.book),
                hintText: 'Enter the subject(s) for which you require teacher',
                labelText: 'The subject(s) for which you require teacher ',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid subjects';
                }
                if (value.length > 200) {
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
            new Container(
                padding:
                    const EdgeInsets.only(left: 110.0, right: 130.0, top: 40.0),
                child: new RaisedButton(
                  child: const Text("Submit"),
                  onPressed: () async {
                    // It returns true if the form is valid, otherwise returns false
                    if (widget._image == null) {
                      setState(() {
                        widget.error = "Please upload the image!";
                      });
                    } else if (_formKey.currentState.validate() &&
                        widget._image != null) {
                      print("right1");
                      dynamic result = await UpdateStudent(uid: user.uid)
                          .updateStudentDetails(
                              widget._image,
                              widget.name,
                              widget.phone,
                              widget.age,
                              widget.address,
                              widget.gender,
                              widget.standard,
                              widget.subjects);
                      print("right4");
                      if (result != null) {
                        // print("right2");
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Toast.show("Profile Updated", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      } else {
                        setState(() {
                          widget.error = 'Error in Details';
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
