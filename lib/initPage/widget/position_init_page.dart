import 'package:calarm/menu/guardian.dart';
import 'package:calarm/menu/senior.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionInit extends StatefulWidget {
  const PositionInit({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  _PositionInitState createState() => _PositionInitState();
}

class _PositionInitState extends State<PositionInit> {
  late User _user;
  bool seniorButton = true;
  bool guardianButton = true;
  final textController = TextEditingController();

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        builder: () => Scaffold(
            backgroundColor: Color(0xFFFFA800),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  elevation: 4.0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                          0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100.h,
                          ),
                          Text(
                            "당신은 누구입니까?",
                            style: TextStyle(
                              fontSize: 18,
                              // fontFamily:
                            ),
                          ),
                          Text(
                            "어르신 먼저 가입하셔야 합니다!",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFA800)
                            ),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 260.w, height: 65.h),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: seniorButton ? Color(0xFFFFB800) : Color(0xFFFFE5A1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    seniorButton = false;
                                    guardianButton = true;
                                  });
                                  var collection = FirebaseFirestore.instance
                                      .collection('Users');
                                  collection
                                      .doc(_user.uid)
                                      .update(
                                      {'position': 1}) // <-- Updated data
                                      .then((_) => print('Success'))
                                      .catchError(
                                          (error) => print('Failed: $error'));
                                },
                                child: Text(
                                  "어르신",
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 260.w, height: 65.h),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: guardianButton ? Color(0xFFFFB800) : Color(0xFFFFE5A1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    seniorButton = true;
                                    guardianButton = false;
                                  });
                                  var collection = FirebaseFirestore.instance
                                      .collection('Users');
                                  collection
                                      .doc(_user.uid)
                                      .update(
                                      {'position': 2}) // <-- Updated data
                                      .then((_) => print('Success'))
                                      .catchError(
                                          (error) => print('Failed: $error'));
                                },
                                child: Text(
                                  "가족원",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 260.w, height: 40.h),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFFA800),
                                ),
                                onPressed: () {
                                  moveToAlarmPage(_user);
                                },
                                child: Text(
                                  "완료",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                        ],
                      )),
                )
              ],
            )));
  }

  Future<void> moveToAlarmPage(User? _user) async {
    bool warning = false;
    bool alreadyexist = false;
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc(_user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();

    CollectionReference groups = FirebaseFirestore.instance.collection('Groups');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance.collection('Groups').get();

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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState){
              return AlertDialog(
                content: Container(
                  width: double.infinity,
                  height: 122,
                  child: Column(
                    children: <Widget>[
                      Text('연결할 어르신의 계정을 입력하세요',
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      TextField(
                        controller: textController,
                        style: TextStyle(
                          fontSize: 16,
                          height: 2.0,
                          color: Colors.black,
                        ),
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        //   labelText: 'e-mail',
                        // )
                      ),
                      Container(
                        width: 265,
                        alignment: Alignment.centerLeft,
                        child: new Text('연결할 어르신이 존재하지 않거나 이미 연결된 어르신입니다',
                            style: warning ? TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFF0000)
                            ) : TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFFFFF)
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(
                                  Color(0xFFFFFFFF)),
                              foregroundColor:
                              MaterialStateProperty.all(
                                  Color(0xFFFFB800)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Color(0xFFFFB800))))),
                          child: Text(
                            '취소',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFB800), // background
                              onPrimary: Colors.white, // foreground
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(10))),
                          child: Text(
                            '확인',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              int j;
                              for (j = 0; j < querySnapshot1.docs.length; j++){
                                var b = querySnapshot1.docs[j];

                                if (b.get('Guardian_email') == data?['email'] && textController.text == b.id){
                                  alreadyexist = true;
                                  break;
                                }
                              }

                              if (j == (querySnapshot1.docs.length)){
                                alreadyexist = false;
                              }
                              if (!alreadyexist){
                                int i;
                                for (i = 0; i < querySnapshot.docs.length; i++){
                                  var a = querySnapshot.docs[i];

                                  if (textController.text == a.get('email') && textController.text != data?['email']) {
                                    groups.doc(a.get('email')).set({
                                      'Guardian_email' : data?['email'],
                                      'Senior_email' : a.get('email'),
                                    });
                                    warning = false;
                                    break;
                                  }
                                }

                                if (i == (querySnapshot.docs.length)){
                                  warning = true;
                                }
                              }
                            });

                            if (warning == false){
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MenuGuardian(
                                    user: _user,
                                    email: textController.text,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
          }
      );
    }
  }
}
