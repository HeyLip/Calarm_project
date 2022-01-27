import 'package:calarm/menu/guardian.dart';
import 'package:calarm/menu/senior.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calarm/initPage/widget/google_sign_in_botton.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    //TODO 이 부분이 자동로그인!
    if (user != null) {
      moveToAlarmPage(user, context);
    }
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  static Future<void> moveToAlarmPage(User? _user, BuildContext context) async {
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc(_user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Groups').get();

    // You can then retrieve the value from the Map like this:
    var value = data?['position'];
    if (value == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MenuSenior(
            user: _user,
          ),
        ),
      );
    } else if (value == 2) {
      String senior_email = 'none';

      for (int i = 0; i < querySnapshot.docs.length; i++){
        var a = querySnapshot.docs[i];
        if (data?['email'] == a.get('Guardian_email')){
          senior_email = a.get('Senior_email');
          break;
        }
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MenuGuardian(
            user: _user,
            email: senior_email,
          ),
        ),
      );
    }
  }
}
