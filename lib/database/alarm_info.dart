class AlarmInfo {
  int? id;
  String title;
  DateTime alarmDateTime;
  String loopInform;
  int gradientColorIndex;
  int sendIconColorIndex;

  AlarmInfo(
      {this.id,
       required this.title,
       required this.alarmDateTime,
       required this.loopInform,
       required this.gradientColorIndex,
       required this.sendIconColorIndex});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
    id: json["id"],
    title: json["title"],
    alarmDateTime: DateTime.parse(json["alarmDateTime"]),
    loopInform: json["loopInform"],
    gradientColorIndex: json["gradientColorIndex"],
    sendIconColorIndex: json["sendIconColorIndex"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "alarmDateTime": alarmDateTime.toIso8601String(),
    "loopInform": loopInform,
    "gradientColorIndex": gradientColorIndex,
    "sendIconColorIndex": sendIconColorIndex,
  };
}
