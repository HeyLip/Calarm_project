// import 'package:calarm/alarmWindow/alarmWindow.dart';
import 'package:calarm/settingPage/setting_for_senior.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calarm/database/alarm_helper.dart';
import 'package:calarm/database/alarm_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calarm/theme_data.dart';
// import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class MenuSenior extends StatefulWidget {
  const MenuSenior( {
    Key? key, required User user
  }) :  _user = user, super(key: key);


  final User _user;

  @override
  _MenuSeniorState createState() => _MenuSeniorState();
}

class _MenuSeniorState extends State<MenuSenior> {
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  bool _isVibration = true;
  String dropdownMin = '1분';
  String dropdownCount = '1회';
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms = AlarmHelper.instance.getAlarms();


  @override
  Widget build(BuildContext context) {
    //   NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    // bool didNotificationLaunchApp = flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().didNotificationLaunchApp ?? false;
    //    if (didNotificationLaunchApp == false){
    //     return AlarmWindow(selectedNotificationPayload);
    //   }

    CollectionReference database =
    FirebaseFirestore.instance.collection('Groups').doc(_user.email).collection('Alarms');

    Future getDocs() async {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Groups').doc(_user.email).collection('Alarms').get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        var alarmInfo = AlarmInfo(
          id: a.get('id'),
          title: a.get('title'),
          alarmDateTime: a.get('alarmDateTime').toDate(),
          loopInform: a.get('loopInform'),
          gradientColorIndex: a.get('gradientColorIndex'),
          sendIconColorIndex: 0,
        );
        AlarmHelper.instance.insertAlarm(alarmInfo).then((_) => setState(() {
          _alarms = AlarmHelper.instance.getAlarms();
          if (mounted) setState(() {});
        }));
        database.doc(a.id).delete();
        scheduleAlarm(a.get('alarmDateTime').toDate(), alarmInfo);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('알람', style: TextStyle(color: Color(0xFF3A3A3A))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.manage_accounts, color: Color(0xFFFFB800)),
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => settingForSenior(
                      user: _user,
                    )),
              );
            },
          )
        ],
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFF4F4F4),
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<AlarmInfo>>(
                  future: _alarms,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AlarmInfo>> snapshot) {
                    getDocs();
                    if (!snapshot.hasData) {
                      return Center(child: Text('Loading...'));
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text('No Alarms in List'));
                    } else {
                      return ListView(
                        children: snapshot.data!.map<Widget>((alarm) {
                          var alarmTime =
                          DateFormat('hh:mm').format(alarm.alarmDateTime);
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
                                      color: Color(0xFF3A3A3A),
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
                                  width: 295,
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            DateFormat('aa')
                                                .format(alarm.alarmDateTime),
                                            style: TextStyle(
                                                color: Color(0xFF3A3A3A)),
                                          ),
                                          Text(
                                            alarmTime,
                                            style: TextStyle(
                                                color: Color(0xFF3A3A3A),
                                                fontFamily: 'avenir',
                                                fontSize: 35,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 40),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.play_arrow,
                                                size: 20,
                                                color: Color(0xFF3A3A3A),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                width: 95,
                                                child: Text(
                                                  alarm.title,
                                                  style: TextStyle(
                                                      color: Color(0xFF3A3A3A),
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
                                                    color: Color(0xFF3A3A3A),
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
                                //SizedBox(width: 10,),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
// <<<<<<< HEAD
// =======

//   Future<void> scheduleAlarm(
//       DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'full screen channel id',
//       'full screen channel name',
//       'full screen channel description',
//       priority: Priority.high,
//       importance: Importance.high,
//       fullScreenIntent: true,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('epic_sax'),
//       // showWhen: AlarmWindow.alarmTime,
//     );

//     var platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
// >>>>>>> 956e142fc4e3a6aa16d1c23e13f401c235c1da53

  Future<void> scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Calarm',
      alarmInfo.title,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.UTC),
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'full screen channel id',
            'full screen channel name',
            'full screen channel description',
            priority: Priority.high,
            importance: Importance.high,
            fullScreenIntent: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('epic_sax'),
            onlyAlertOnce: true,
            //  showWhen: AlarmWindow.alarmTime,
          )),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: alarmInfo.title,
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
