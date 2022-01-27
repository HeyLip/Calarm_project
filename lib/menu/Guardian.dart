import 'package:calarm/settingPage/setting_for_guardian.dart';
import 'package:calarm/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calarm/database/alarm_helper.dart';
import 'package:calarm/database/alarm_info.dart';
import 'package:calarm/alarmSetting/new_alarm.dart';
import 'package:intl/intl.dart';

class MenuGuardian extends StatefulWidget {
  const MenuGuardian({Key? key, required User user, required String email})
      : _user = user,
        _email = email,
        super(key: key);

  final User _user;
  final String _email;
  @override
  _MenuGuardianState createState() => _MenuGuardianState();
}

class _MenuGuardianState extends State<MenuGuardian> {
  late User _user;
  late String senior_email;

  @override
  void initState() {
    _user = widget._user;
    senior_email = widget._email;
    super.initState();
  }

  int? selectedId;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms = AlarmHelper.instance.getAlarms();

  Color fontColor(int num) {
    if (num == 0) {
      return Color(0xFF3A3A3A);
    } else {
      return Color(0xFF909090);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = FirebaseFirestore.instance
        .collection('Groups')
        .doc(senior_email)
        .collection('Alarms');

    return Scaffold(
      appBar: AppBar(
        title: Text('알람', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.manage_accounts, color: Color(0xFFFFB800)),
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        settingForGuardian(user: _user, email: senior_email),
                  ));
            },
          )
        ],
        elevation: 0,
      ),

      body: Container(
        color: Color(0xFFF4F4F4),
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<AlarmInfo>>(
                  future: _alarms,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AlarmInfo>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('Loading...'));
                    }
                    return snapshot.data!.isEmpty
                        ? Center(child: Text('No Alarms in List'))
                        : ListView(
                            children: snapshot.data!.map<Widget>((alarm) {
                              var alarmTime = DateFormat('hh:mm')
                                  .format(alarm.alarmDateTime);
                              var gradientColor = GradientTemplate
                                  .gradientTemplate[alarm.gradientColorIndex]
                                  .colors;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColor,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    if (alarm.gradientColorIndex == 0)
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        blurRadius: 3,
                                        spreadRadius: 2,
                                        offset: Offset(4, 4),
                                      ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 40,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                          ),
                                          iconSize: 30,
                                          color: fontColor(
                                              alarm.gradientColorIndex),
                                          onPressed: () {
                                            deleteAlarm(alarm.id);
                                          }),
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 113,
                                      child: VerticalDivider(
                                        color: Color(0xFFCCCCCC),
                                        thickness: 1.0,
                                      ),
                                    )),
                                    SizedBox(
                                      width: 225,
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                DateFormat('aa').format(
                                                    alarm.alarmDateTime),
                                                style: TextStyle(
                                                    color: fontColor(alarm
                                                        .gradientColorIndex)),
                                              ),
                                              Text(
                                                alarmTime,
                                                style: TextStyle(
                                                    color: fontColor(alarm
                                                        .gradientColorIndex),
                                                    fontFamily: 'avenir',
                                                    fontSize: 35,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.play_arrow,
                                                    size: 20,
                                                    color: fontColor(alarm
                                                        .gradientColorIndex),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    width: 95,
                                                    child: Text(
                                                      alarm.title,
                                                      style: TextStyle(
                                                          color: fontColor(alarm
                                                              .gradientColorIndex),
                                                          fontFamily: 'avenir',
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    alarm.loopInform,
                                                    style: TextStyle(
                                                        color: fontColor(alarm
                                                            .gradientColorIndex),
                                                        fontFamily: 'avenir',
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                        child: Container(
                                      height: 113,
                                      child: VerticalDivider(
                                        color: Color(0xFFCCCCCC),
                                        thickness: 1.0,
                                      ),
                                    )),

                                    IconButton(
                                        icon: Icon(
                                            CupertinoIcons.paperplane_fill),
                                        iconSize: 30,
                                        color: FontColors
                                            .colors[alarm.sendIconColorIndex],
                                        onPressed: () {
                                          if (alarm.sendIconColorIndex == 0) {
                                            database.add({
                                              'id': alarm.id,
                                              'title': alarm.title,
                                              'alarmDateTime':
                                                  Timestamp.fromDate(
                                                      alarm.alarmDateTime),
                                              'gradientColorIndex':
                                                  alarm.gradientColorIndex,
                                              'loopInform': alarm.loopInform,
                                            }).then((_) => setState(() {
                                                  AlarmHelper.instance
                                                      .update(AlarmInfo(
                                                    id: alarm.id,
                                                    title: alarm.title,
                                                    alarmDateTime:
                                                        alarm.alarmDateTime,
                                                    loopInform:
                                                        alarm.loopInform,
                                                    gradientColorIndex: 0,
                                                    sendIconColorIndex: 1,
                                                  ));
                                                  _alarms = AlarmHelper.instance
                                                      .getAlarms();
                                                  if (mounted) setState(() {});
                                                }));
                                          }
                                        })

                                    //SizedBox(width: 10,),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                  }),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: 350,
        height: 70,
        child: FloatingActionButton.extended(
          backgroundColor: Color(0xFFFFB800),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
              return NewAlarm(
                title: "Connect with alarm",
              );
            })).then((_) => setState(() {
                  _alarms = AlarmHelper.instance.getAlarms();
                  if (mounted) setState(() {});
                }));
          },
          label: Text('새 알람 추가',
              style: TextStyle(
                  color: Color(0xFF3A3A3A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          icon: Icon(Icons.add, size: 28, color: Color(0xFF3A3A3A)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void deleteAlarm(int? id) {
    if (id != null) {
      _alarmHelper.delete(id);
    }
    _alarms = AlarmHelper.instance.getAlarms();
    if (mounted) setState(() {});
  }
}
