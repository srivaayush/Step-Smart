import 'package:etutor/models/user.dart';
import 'package:etutor/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  //create user obj based on firebase user
  User _userfromfirebaseuser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userfromfirebaseuser(user));
        .map(_userfromfirebaseuser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userfromfirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user.isEmailVerified) {
        print("verified");
        return _userfromfirebaseuser(user);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //print("user created");
      try {
        await user.sendEmailVerification();
        //print("mail send successfully");
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
        return null;
      }
      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('Unknown', 'student', 'Gorakhpur');
      return _userfromfirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //password reset
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return null;
    }
  }

  Future signInWithGoogle() async{
    try{

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      print(" accessToken="+googleSignInAuthentication.accessToken);

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      await DatabaseService(uid: user.uid).updateGoogleUserData('Unknown', 'student', 'Gorakhpur');

      return _userfromfirebaseuser(user);

    }
    catch(e){
      print(e.code);
    }
  }

  Future<void> googleSignOut() async{
    await _auth.signOut().then((onValue){
      _googleSignIn.signOut();
    });
  }
}
