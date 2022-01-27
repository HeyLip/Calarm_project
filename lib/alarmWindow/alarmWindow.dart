import 'package:calarm/alarmWindow/slideAction.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../theme_data.dart';

class AlarmWindow extends StatefulWidget {
  const AlarmWindow(
    this.payload, {
    Key? key,
  }) : super(key: key);

  static const String routeName = "/alarmWindow";
  final String? payload;

  @override
   State<StatefulWidget> createState() => _AlarmWindowState();
}

class _AlarmWindowState extends State<AlarmWindow> {
  
  static DateTime alarmTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var alarmTimeFormet1 = DateFormat('aa').format(alarmTime) == 'AM' ? '오전':'오후';
    var alarmTimeFormet2 = DateFormat('hh:mm').format(alarmTime);
    double screenWidth = MediaQuery.of(context).size.width;

    Container alarmTimeText = Container(
        width:screenWidth,
        margin: EdgeInsets.symmetric(horizontal: 37),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width:screenWidth,
              child: Text(
                alarmTimeFormet1,
                style: TextStyle(
                    color: AlarmWindowColors.timeColor,
                    fontFamily: 'NanumGothic',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width:screenWidth,
              child: Text(
                alarmTimeFormet2,
                style: TextStyle(
                    color: AlarmWindowColors.timeColor,
                    fontFamily: 'BMDOHYEON',
                    fontSize: 80,
                    shadows: [
                      Shadow(
                        color: AlarmWindowColors.shadowColor,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 5,
                        // spreadRadius: 1.0,
                      ),
                    ]
                    ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ));

    Container commentBox = Container(
        margin: EdgeInsets.symmetric(horizontal: 37),
        padding: EdgeInsets.all(20),
        width: screenWidth - 10,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          border: Border.all(
            color: Colors.white.withOpacity(0),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        // alignment: Alignment.topLeft,
        child: Text(
              widget.payload ?? " ",
              style: TextStyle(
                color: AlarmWindowColors.textColor2,
                fontSize: 28,
                fontFamily: 'NanumBarunGothic',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.03,
                height: 1.25,
              ),
              textAlign: TextAlign.left,
            ),
        );

    Builder slideToOff = Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SlideAction(
            height: 60,
            innerColor: Colors.white,
            outerColor: AlarmWindowColors.sliderColor,
            sliderButtonIconSize: 14,
            borderRadius: 100, 
            text: "밀어서 알람끄기",
            onSubmit: () => 
            // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
            Navigator.pop(context),
          ),
        );
      },
    );

    Container slideToOffContainer = Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      child: slideToOff,
    );

    return Scaffold(
        body: Center(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.25, 0.75, 1.0],
              colors: [
                AlarmWindowColors.backgroundColor1,
                AlarmWindowColors.backgroundColor2,
                AlarmWindowColors.backgroundColor3,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.only(top: 100)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Column(
                      children: [
                        alarmTimeText, 
                        Padding(padding: EdgeInsets.only(top:40))
                        ,commentBox,
                      ]
                    ),
                    slideToOffContainer
                    ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
            ],
          )),
    ));
  }
}