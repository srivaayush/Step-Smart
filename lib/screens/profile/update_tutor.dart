import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateTutor {
  final String uid;
  UpdateTutor({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateTutorDetails(
    File img,
    String name,
    int phone,
    int age,
    String address,
    String city,
    String gender,
    String subjects,
    int fees,
    String acad,
    String experience,
    String mode,
    String institute,
    String yt,
  ) async {
    String fileName = uid;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(img);
    // ignore: unused_local_variable
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot.error != null) {
      return null;
    }
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    try {
      await userCollection.document(uid).setData({
        'name': name,
        'occupation': "teacher",
        'phone': phone,
        'age': age,
        'address': address,
        'gender': gender,
        'acad': acad,
        'subjects': subjects,
        'experience': experience,
        'yt': yt,
        'flag': 1,
        'city': city,
        'fees': fees,
        'mode': mode,
        'institute': institute,
        'rating': 0,
        'rateUser': 0,
        'img': {"url": downloadUrl, "name": uid},
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    return true;
  }

  Future updateRating(int rating) async {
    try {
      await userCollection.document(uid).updateData({
        'rating': FieldValue.increment(rating),
        'rateUser': FieldValue.increment(1),
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    return true;
  }
}
