import 'dart:typed_data';
import 'package:calarm/database/alarm_helper.dart';
import 'package:calarm/database/alarm_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme_data.dart';

class NewAlarm extends StatefulWidget {
  NewAlarm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewAlarmState createState() => _NewAlarmState();
}

class _NewAlarmState extends State<NewAlarm> {
  // 현재시각.
  static final DateTime currentTime = DateTime.now();
  // TimePicker 에서 받아온 알람 울릴 시각, 현재시각보다 이르면 다음날로 저장.
  DateTime timeFromPicker =DateTime.now();
  // Calendar 에서 받아온 날짜. 현재 시각으로 초기화되어 있음.
  DateTime dateFromCalender = currentTime;
  // 반복날자 혹은 알람 울릴 날짜 저장하는 변수. 현재시각으로 초기화되어있음.
  DateTime firstDateOfCalender = currentTime;
  // 요일 선택여부(일월화수목금토).
  List<bool> isPicked = [false,false,false,false,false,false,false];
  // 요일들 string 으로 나타낼 때 쓸 수 있는 변수.
  static List<String> days = ['일', '월', '화', '수', '목', '금', '토'];

  // 언제 알람이 울리는지에 대한 알림글, 현재시각으로 초기화되어 있음.
  String loopInform = currentTime.month.toString()+"월 " +currentTime.day.toString()+"일 "+days[currentTime.weekday]+"요일 "+"한 번 울림";
  String loopInform1 = currentTime.month.toString()+"월 " +currentTime.day.toString()+"일 "+days[currentTime.weekday]+"요일";
  // 알람의 이름을 받아오는 변수.
  String alarmName = "이름없는 알람";
  // 알람과 함께 진동을 울릴지에 대한 여부를 받아오는 변수.
  bool isVibrate = false;
  // 알람의 다시울림 여부.
  bool isRepeat = false;

  CollectionReference database =
  FirebaseFirestore.instance.collection('example');

  var iconForUproad = Icons.add;
  String? uploadedFileName;

  @override
  Widget build(BuildContext context) {
    // 테스트용 코드
    if(isVibrate && isRepeat) print(alarmName+"-> 진동, 반복");
    else if(isVibrate) print(alarmName+"-> 진동");
    else if(isRepeat) print(alarmName+"-> 반복");
    else print(alarmName+"-> ...");
    print("timeFromPicker: $timeFromPicker");
    // print("dateFromCalender: $dateFromCalender");
    String pickedWeekDays = "";
    for(int i=0; i<7; i++){
      if(isPicked[i]) pickedWeekDays += days[i]+"  ";
    }
    print("pickedWeekDays: $pickedWeekDays");
    print("");
    print("");
    // 여기까지 테스트용.

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          shadowColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView(
                // physics:  ClampingScrollPhysics(), // 스크롤이 되지만, 끝에 다다랐을 때 효과가 없다.
                // physics: NeverScrollableScrollPhysics (), // 스크롤 금지
                children: [
                  timePicker(),
                  optionBox(),
                ],
              ),
            ),
            cancelSaveButton(),
            Padding(padding: EdgeInsets.only(bottom: 20))
          ],
        ));
  }

  // 쿠퍼티노스타일 타임피커. timeFromPicker 에 받아온 DateTime 저장.
  Container timePicker() {
    return Container(
      // margin: EdgeInsets.only(top: 0),
      // height: MediaQuery.of(context).copyWith().size.height / 3,  // 어떻게 쓰는거지?
        height: 230,
        child: CupertinoDatePicker(
          initialDateTime: currentTime,
          onDateTimeChanged: (DateTime newdate) {
            setState(() {
              loopInformSetterTimePicker(newdate);
            });
          },
          use24hFormat: false,
          minuteInterval: 1,
          mode: CupertinoDatePickerMode.time,
        ));
  }

  // 모서리가 둥근 회색 컨테이너이다. 알람의 설정들을 할 수 있는 위젯들을 포함한다.
  Container optionBox() {
    return Container(
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: NewAlarmColors.optionBoxColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0) // POINT
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loopInform,
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () async{
                        Future<DateTime?> future = showDatePicker(
                          context: context,
                          locale: const Locale("ko", "KR"),
                          initialDate: dateFromCalender,
                          firstDate: firstDateOfCalender,
                          lastDate: DateTime(2050),
                        );
                        future.then((date) {loopInformSetterCalender(date);});
                      },
                      icon: Icon(Icons.calendar_today))
                ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (int dayNum = 0; dayNum < 7; dayNum++)
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: isPicked[dayNum]
                                  ? NewAlarmColors.underLineColor2
                                  : NewAlarmColors.underLineColor1),
                        ),
                      ),
                      child: TextButton(
                        //바탕이랑 오버레이 색이랑 똑같이 해서 안보이게 해둠. 아예 오버레이를 없애는 법은없으려나.
                          style: ButtonStyle(overlayColor:
                          MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                return NewAlarmColors.optionBoxColor;
                              })),
                          onPressed: () {
                            setState(() {
                              isPicked[dayNum] = !isPicked[dayNum];
                            });
                            loopInformSetterWeekdays();
                          },
                          child: Text(
                            days[dayNum],
                            style: TextStyle(
                                fontSize: 16, color: NewAlarmColors.dayColor[dayNum]),
                          ))),
                ),
            ])
          ]),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: true,
                    decoration: InputDecoration.collapsed(
                      hintText: "알람이름",
                      border: InputBorder.none,
                    ),
                    // controller: _controller,
                    onSubmitted: (String value) async {
                      setState(() {
                        alarmName = value;
                      });
                    }),
                Padding(padding: EdgeInsets.only(top: 10)),
                Divider(color: NewAlarmColors.dividerColor),
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(1000, 60),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        setState(() {
                          isVibrate = !isVibrate;
                        });
                      },
                      child: Text("알람과 함께 진동",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Positioned(
                      right: 0,
                      child: Switch(
                        value: isVibrate,
                        onChanged: (bool newValue) {
                          setState(() {
                            isVibrate = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Divider(color: NewAlarmColors.dividerColor),
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(1000, 60),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        setState(() {
                          isRepeat = !isRepeat;
                        });
                      },
                      child: Text("다시 울림",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Positioned(
                      right: 0,
                      child: Switch(
                        value: isRepeat,
                        onChanged: (bool newValue) {
                          setState(() {
                            isRepeat = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Divider(color: NewAlarmColors.dividerColor),
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(1000, 60),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          Uint8List? fileBytes = result.files.first.bytes;
                          String fileName = result.files.first.name;
                          
                          // Upload file 
                          // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
                          setState(() {
                            iconForUproad = Icons.check;
                            uploadedFileName = fileName.length<20 ? fileName : "${fileName.substring(0,21)} ...";
                            uploadedFileName = "($uploadedFileName)";
                          });
                          print(uploadedFileName);
                        }
                      },
                      child: Row(
                        children: [
                          Text("녹음 파일 업로드",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                          Padding(padding: EdgeInsets.only(left: 11)),
                          Text("${uploadedFileName ?? ""}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.normal))   
                        ]
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Icon(iconForUproad),
                    ),
                  ],
                ),
                Divider(color: NewAlarmColors.dividerColor),
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(1000, 60),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        setState(() {
                          // isRepeat = !isRepeat;
                        });
                      },
                      child: Text("녹음 하기",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Positioned(
                      right: 0,
                      child: Icon(Icons.mic),
                    ),
                  ],
                ),
                Divider(color: NewAlarmColors.dividerColor),
              ],
            ),
          ),
        ]));
  }

  // 화면 최하단의 취소, 저장버튼. 취소와 저장시 루트를 정해주지 않았으므로, onPressed 는 구현하지 않았다.
  Row cancelSaveButton() {
    return Row(children: [
      Expanded(
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "취소",
              style: TextStyle(color: Colors.black),
            )),
      ),
      Expanded(
        child: TextButton(
            onPressed: () async {
              await AlarmHelper.instance.insertAlarm(
                  AlarmInfo(
                    title: alarmName,
                    alarmDateTime: timeFromPicker,
                    loopInform: loopInform1,
                    gradientColorIndex: 0,
                    sendIconColorIndex: 0,
                  )
              );

              setState(() {
                Navigator.pop(context);
              });
            },
            child: Text(
              "저장",
              style: TextStyle(color: Colors.blue),
            )),
      ),
    ]);
  }

  // Calender 에서 받아온 DateTime 을 dateFromCalender 에 저장하고, loopInform 의 상태를 업데이트한다.
  void loopInformSetterCalender(DateTime? dateFromCalenderTmp) {
    if (dateFromCalenderTmp!=null && dateFromCalenderTmp != currentTime) {
      setState(() {
        dateFromCalender = dateFromCalenderTmp;
        for (int i = 0; i < 7; i++) isPicked[i] = false;
      });
      String rst = "한 번 울림";
      String rst1 = "";
      String year = dateFromCalender.year.toString();
      String month = dateFromCalender.month.toString();
      String day = dateFromCalender.day.toString();
      String weekday = days[dateFromCalender.weekday];
      if (dateFromCalender.year > currentTime.year){
        rst = year + "년 " + month + "월 " + day + "일 " + weekday + "요일 " + rst;
        rst1 = year + "년 " + month + "월 " + day + "일 " + weekday + "요일";
      }else{
        rst = month + "월 " + day + "일 " + weekday + "요일 " + rst;
        rst1 = month + "월 " + day + "일 " + weekday + "요일 " + rst1;
      }
      loopInform = rst;
      loopInform1 = rst1;
      return;
    }
  }

  // 요일 버튼의 변동사항을 확인하고, loopInform 의 상태를 업데이트한다.
  void loopInformSetterWeekdays() {
    if (isPicked.contains(true)) {
      setState(() {
        dateFromCalender = firstDateOfCalender;
      });
      if (isPicked.every((element) => element == true)) {
        loopInform = "매일";
        loopInform1 = "매일";
      } else {
        String rst = "매주 ";
        String rst1 = "매주 ";
        for (int i = 0; i < 7; i++) {
          if (isPicked[i] == true) {
            rst += days[i] + ", ";
            rst1 += days[i] + ", ";
          }
        }
        rst = rst.substring(0, rst.length - 2);
        rst1 = rst1.substring(0, rst1.length - 2);
        rst += "요일 울림";
        rst1 += "요일";
        loopInform = rst;
        loopInform1 = rst1;
      }
      return;
    }
    // 요일을 선택했다가 취소하면, 다시 금일 혹은 익일 울림으로 설정해주기 위해.
    else {
      setState(() {
        loopInformSetterTimePicker(timeFromPicker);
      });
    }
  }

  // TimePicker 에서 받아온 DateTime 을 분석해 timeFromPicker 에 저장하고, calender 의 파라미터로 쓰이는 변수들을 업데이트한다.
  void loopInformSetterTimePicker(DateTime newdate) {
    if (newdate.isBefore(DateTime.now())) {
      timeFromPicker = newdate.add(const Duration(days: 1));
      firstDateOfCalender = newdate.add(const Duration(days: 1));
      dateFromCalender = newdate.add(const Duration(days: 1));
    } else {
      timeFromPicker = newdate;
      firstDateOfCalender = newdate;
      dateFromCalender = newdate;
    }
    if (isPicked.contains(true) || dateFromCalender != firstDateOfCalender) return;
    String rst = "한 번 울림";
    String rst1 = "";
    String month = timeFromPicker.month.toString();
    String day = timeFromPicker.day.toString();
    String weekday = days[timeFromPicker.weekday];
    rst = month + "월 " + day + "일 " + weekday + "요일 " + rst;
    rst1 = month + "월 " + day + "일 " + weekday + "요일";
    loopInform = rst;
    loopInform1 = rst1;
    return;
  }
}
