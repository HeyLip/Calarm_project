import 'package:calarm/database/alarm_helper.dart';
import 'package:calarm/initPage/initpage.dart';
import 'package:calarm/menu/guardian.dart';
import 'package:calarm/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//TODO media query 이용해서 비율 맞춰서 수정 보기

class settingForGuardian extends StatefulWidget {
  const settingForGuardian(
      {Key? key, required User user, required String email})
      : _user = user,
        _email = email,
        super(key: key);

  final User _user;
  final String _email;

  @override
  _settingForGuardianState createState() => _settingForGuardianState();
}

class _settingForGuardianState extends State<settingForGuardian> {
  late User _user;
  late String senior_email;

  void initState() {
    _user = widget._user;
    senior_email = widget._email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isSigningOut = false;
    final med = MediaQuery.of(context);
    final medWidth = med.size.width;
    final medHeight = med.size.height - med.padding.top;

    Route _routeToSignInScreen() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => InitPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        appBar: AppBar(
          title: Text("설정 페이지",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  child: Card(
                    color: Color(0xFFFFA800),
                    margin: EdgeInsets.fromLTRB(medWidth * 0.03,
                        medHeight * 0.065, medWidth * 0.03, medHeight * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4.0,
                    child: Container(
                      width: medWidth * 0.97,
                      height: medHeight * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          LayoutBuilder(
                            builder: (context, constraints) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(height: constraints.maxHeight * 0.7),
                                Column(children: <Widget>[
                                  Text(
                                    "총 알람 갯수",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  FutureBuilder(
                                      future: getAlarmsRowCount(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                        if (snapshot.hasData == false) {
                                          return CircularProgressIndicator();
                                        }
                                        //error가 발생하게 될 경우 반환하게 되는 부분
                                        else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                        else {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white),
                                          );
                                        }
                                      }),
                                ]),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SizedBox(height: constraints.maxHeight * 0.65),
                                Text(
                                  "알람 내역 보기",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Card(
                    color: Color(0xFFFFB800),
                    margin: EdgeInsets.fromLTRB(medWidth * 0.03,
                        medHeight * 0.065, medWidth * 0.03, medHeight * 0.065),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4.0,
                    child: Container(
                      width: medWidth * 0.97,
                      height: medHeight * 0.37,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    constraints.maxWidth * 0.08,
                                    constraints.maxHeight * 0.12,
                                    0.0,
                                    0.0),
                                child: Text(
                                  "나",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0,
                                          constraints.maxHeight * 0.03,
                                          0.0,
                                          constraints.maxHeight * 0.03),
                                      child: Text(
                                        _user.email!,
                                        style: TextStyle(
                                            fontSize: 23, color: Colors.white),
                                      ),
                                    ),
                                  ]),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 10.0, 30.0, 0.0),
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    constraints.maxWidth * 0.08,
                                    constraints.maxHeight * 0.04,
                                    0.0,
                                    0.0),
                                child: Text(
                                  "연결된 어르신",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FutureBuilder(
                                      future: getSeniorEmail(_user),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                        if (snapshot.hasData == false) {
                                          return CircularProgressIndicator();
                                        }
                                        //error가 발생하게 될 경우 반환하게 되는 부분
                                        else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                        else {
                                          return Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0,
                                                constraints.maxHeight * 0.05,
                                                0.0,
                                                constraints.maxHeight * 0.07),
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: constraints.maxWidth * 0.85,
                                        height: constraints.maxHeight * 0.12),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        shape: StadiumBorder(),
                                      ),
                                      child: Text("연결된 어르신 변경"),
                                      onPressed: () {
                                        regroupSenior(_user, context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: medWidth,
              height: medHeight * 0.22,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        medWidth * 0.04, 0, medWidth * 0.04, 0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "서비스 탈퇴",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      // TODO 서비스 탈퇴 팝업 부분
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              content: Container(
                                  margin: EdgeInsets.all(0),
                                  width: medWidth,
                                  height: medHeight * 0.28,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(height: medHeight * 0.05),
                                      const Text(
                                        "정말 탈퇴하시겠어요?? ㅠㅠ",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: medHeight * 0.05),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: Size(medWidth * 0.31,
                                                  medHeight * 0.08),
                                              primary: Color(0xFFFFB800),
                                              side: BorderSide(
                                                  color: Color(0xFFFFB800),
                                                  width: 2),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text(
                                              "취소",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: medWidth * 0.05),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(medWidth * 0.31,
                                                  medHeight * 0.08),
                                              primary: Color(0xFFFFB800),
                                            ),
                                            onPressed: () {
                                              deleteUser(_user);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InitPage()));
                                            },
                                            child: const Text(
                                              "서비스 탈퇴",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: medWidth * 0.95, height: medHeight * 0.07),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuGuardian(user: _user, email: senior_email),
                        ));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  label: Text(
                    "설정 페이지 나가기",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> deleteUser(User? _user) {
    return usersCollection
        .doc(_user!.uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<String?> getSeniorEmail(User _user) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Groups').get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      var senior_email = " ";
      if (_user.email == a.get('Guardian_email')) {
        // ignore: non_constant_identifier_names
        senior_email = a.get('Senior_email');
      }
      return senior_email;
    }
  }

  Future<int?> getAlarmsRowCount() async {
    int alarms_rowCount = await AlarmHelper.instance.getRowCount();
    return alarms_rowCount;
  }

  Future<void> regroupSenior(User? _user, BuildContext context) async {
    bool warning = false;
    bool alreadyexist = false;
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc(_user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    final textController = TextEditingController();

    CollectionReference groups =
        FirebaseFirestore.instance.collection('Groups');
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection('Groups').get();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
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
                          style: warning
                              ? TextStyle(
                                  fontSize: 14, color: Color(0xFFFF0000))
                              : TextStyle(
                                  fontSize: 14, color: Color(0xFFFFFFFF))),
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
                                MaterialStateProperty.all(Color(0xFFFFFFFF)),
                            foregroundColor:
                                MaterialStateProperty.all(Color(0xFFFFB800)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side:
                                        BorderSide(color: Color(0xFFFFB800))))),
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
                                borderRadius: new BorderRadius.circular(10))),
                        child: Text(
                          '확인',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          setState(() {
                            int j;
                            for (j = 0; j < querySnapshot1.docs.length; j++) {
                              var b = querySnapshot1.docs[j];

                              if (b.get('Guardian_email') == data?['email'] &&
                                  textController.text == b.id) {
                                alreadyexist = true;
                                break;
                              }
                            }

                            if (j == (querySnapshot1.docs.length)) {
                              alreadyexist = false;
                            }
                            if (!alreadyexist) {
                              int i;
                              for (i = 0; i < querySnapshot.docs.length; i++) {
                                var a = querySnapshot.docs[i];

                                if (textController.text == a.get('email') &&
                                    textController.text != data?['email']) {
                                  for (j = 0;
                                      j < querySnapshot1.docs.length;
                                      j++) {
                                    var b = querySnapshot1.docs[j];

                                    if (b.get('Guardian_email') ==
                                        data?['email']) {
                                      groups
                                          .doc(b.get('Senior_email'))
                                          .delete();
                                    }
                                  }
                                  groups
                                      .doc(a.get('email'))
                                      .set({
                                        'Guardian_email': data?['email'],
                                        'Senior_email': a.get('email'),
                                      })
                                      .then((value) =>
                                          print("Create new group doc"))
                                      .catchError((error) => print(
                                          "Failed to create new group doc: $error"));
                                  warning = false;
                                  break;
                                }
                              }

                              if (i == (querySnapshot.docs.length)) {
                                warning = true;
                              }
                            }
                          });

                          if (warning == false) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }
}

Future<String?> getSeniorEmail(User _user) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Groups').get();

  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var a = querySnapshot.docs[i];
    if (_user.email == a.get('Guardian_email')) {
      var senior_email = a.get('Senior_email');
      return senior_email;
    }
  }
}
