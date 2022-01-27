import 'package:calarm/initPage/widget/position_init_page.dart';
import 'package:calarm/menu/guardian.dart';
import 'package:calarm/menu/senior.dart';
import 'package:calarm/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final med = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: med.size.width * 0.75,
                          height: med.size.height * 0.06),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFA800),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isSigningIn = true;
                          });

                          User? _user = await Authentication.signInWithGoogle(
                              context: context);

                          setState(() {
                            _isSigningIn = false;
                          });

                          //TODO 구글에서 로그인 정보 가져와 firebase의 user에 넣기
                          var UserData =
                              await usersCollection.doc(_user!.uid).get();

                          // ignore: unnecessary_null_comparison
                          if (!UserData.exists) {
                            addUser(_user);

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => PositionInit(user: _user),
                              ),
                            );
                          } else {
                            moveToAlarmPage(_user);
                          }
                        },
                        child: LayoutBuilder(
                          builder: (context, constraints) => Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: constraints.maxHeight * 0.55,
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.06,
                              ),
                              Text(
                                "Google로 로그인",
                                style: TextStyle(
                                  fontSize: 16.7,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> addUser(User? user) {
    // Call the user's CollectionReference to add a new user
    return usersCollection
        .doc(user?.uid)
        .set({
          'display_Name': user?.displayName!,
          'email': user?.email!,
          'position': null,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> moveToAlarmPage(User? _user) async {
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc(_user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Groups').get();

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

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        if (data?['email'] == a.get('Guardian_email')) {
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
