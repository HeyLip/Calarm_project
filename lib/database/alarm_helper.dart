import 'package:calarm/database/alarm_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'alarmDateTime';
final String columnloopInform = 'loopInform';
final String columnColorIndex = 'gradientColorIndex';
final String columnSendColorIndex = 'sendIconColorIndex';

class AlarmHelper {
  AlarmHelper._privateConstructor();
  static final AlarmHelper instance = AlarmHelper._privateConstructor();

  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();

  factory AlarmHelper() => _alarmHelper ??= AlarmHelper._createInstance();

  Future<Database> get database async =>
      _database ??= await initializeDatabase();

  Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var dir = await getDatabasesPath();
    String path = join(documentsDirectory.path, dir + "alarm.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
           CREATE TABLE $tableAlarm (
           $columnId integer primary key autoincrement,
           $columnTitle text not null,
           $columnDateTime text not null,
           $columnloopInform text,
           $columnColorIndex integer,
           $columnSendColorIndex integer)
         ''');
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  Future<int> getRowCount() async {
    Database db = await this.database;
    var result = await db.query(tableAlarm);
    int count = result.length;
    return count;
  }

  Future<int> insertAlarm(AlarmInfo alarmInfo) async {
    var db = await this.database;
    return await db.insert(tableAlarm, alarmInfo.toMap());
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(AlarmInfo alarmInfo) async {
    var db = await this.database;
    return await db.update(tableAlarm, alarmInfo.toMap(),
        where: '$columnId = ?', whereArgs: [alarmInfo.id]);
  }

  Future<AlarmInfo> getAlarm(int id) async {
    List<AlarmInfo> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms[id];
  }
}
