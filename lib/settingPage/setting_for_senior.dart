import 'package:calarm/database/alarm_helper.dart';
import 'package:calarm/database/alarm_info.dart';
import 'package:calarm/initPage/initpage.dart';
import 'package:calarm/menu/senior.dart';
import 'package:calarm/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO media query 이용해서 비율 맞춰서 수정 보기

class settingForSenior extends StatefulWidget {
  const settingForSenior({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _settingForSeniorState createState() => _settingForSeniorState();
}

class _settingForSeniorState extends State<settingForSenior> {
  late User _user;

  void initState() {
    _user = widget._user;

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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          constraints.maxHeight * 0.07,
                                          0.0,
                                          constraints.maxHeight * 0.05),
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
                                    constraints.maxHeight * 0.07,
                                    0.0,
                                    0.0),
                                child: Text(
                                  "연결된 가족원",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FutureBuilder(
                                      future: getGuardianEmail(_user),
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
                          builder: (context) => MenuSenior(user: _user)),
                    );
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

  Future<String?> getGuardianEmail(User _user) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Groups').get();

    print(querySnapshot.docs.length);
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      var guardian_email = "연결된 가족원이 없습니다.";
      if (_user.email == a.get('Senior_email')) {
        // ignore: non_constant_identifier_names
        guardian_email = a.get('Guardian_email');
      }
      return guardian_email;
    }
  }

  Future<int?> getAlarmsRowCount() async {
    int alarms_rowCount = await AlarmHelper.instance.getRowCount();
    return alarms_rowCount;
  }
}
