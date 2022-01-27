// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'package:calarm/alarmWindow/alarmWindow.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// /// Streams are created so that app can respond to notification-related events
// /// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String?> selectNotificationSubject =
//     BehaviorSubject<String?>();

// const MethodChannel platform =
//     MethodChannel('dexterx.dev/flutter_local_notifications_example');

// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });

//   final int id;
//   final String title;
//   final String body;
//   final String payload;
// }

// String? selectedNotificationPayload;

// /// IMPORTANT: running the following code on its own won't work as there is
// /// setup required for each platform head project.
// ///
// /// Please download the complete example app from the GitHub repository where
// /// all the setup has been done


// Future<void> configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }

// class PaddedElevatedButton extends StatelessWidget {
//   const PaddedElevatedButton({
//     required this.buttonText,
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);

//   final String buttonText;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//         child: ElevatedButton(
//           onPressed: onPressed,
//           child: Text(buttonText),
//         ),
//       );
// }

// class AlarmExcuter extends StatefulWidget {
//   const AlarmExcuter(
//     this.notificationAppLaunchDetails,
//     this.comment,
//      {
//     Key? key,
//   }) : super(key: key);

//   static const String routeName = '/';

//   final String comment;

//   final NotificationAppLaunchDetails? notificationAppLaunchDetails;

//   bool get didNotificationLaunchApp =>
//       notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

//   @override
//   _AlarmExcuterState createState() => _AlarmExcuterState();
// }

// class _AlarmExcuterState extends State<AlarmExcuter> {
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//     _configureDidReceiveLocalNotificationSubject();
//     _configureSelectNotificationSubject();
//   }

//   void _requestPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   void _configureDidReceiveLocalNotificationSubject() {
//     didReceiveLocalNotificationSubject.stream
//         .listen((ReceivedNotification receivedNotification) async {
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: 
//           // receivedNotification.title != null?
//               Text(receivedNotification.title),
//               // : null,
//           content: 
//           // receivedNotification.body != null ? 
//               Text(receivedNotification.body),
//               // : null,
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () async {
//                 Navigator.of(context, rootNavigator: true).pop();
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) =>
//                         AlarmWindow(),
//                   ),
//                 );
//               },
//               child: const Text('Ok'),
//             )
//           ],
//         ),
//       );
//     });
//   }





//   void _configureSelectNotificationSubject() {
//     selectNotificationSubject.stream.listen((String? payload) async {
//       await Navigator.pushNamed(context, '/alarmWindow');
//     });
//   }




//   @override
//   void dispose() {
//     didReceiveLocalNotificationSubject.close();
//     selectNotificationSubject.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Center(
//                 child: Column(
//                   children: <Widget>[
                    
//                     if (!kIsWeb && Platform.isAndroid) ...<Widget>[




//                       ElevatedButton(
//                         child: Text('Show full-screen notification'),
//                         onPressed: () async {
//                           await _showFullScreenNotification();
//                         },
//                       ),








//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );

//   // Future<void> _showNotification() async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //       AndroidNotificationDetails(
//   //           'your channel id', 'your channel name', 'your channel description',
//   //           importance: Importance.max,
//   //           priority: Priority.high,
//   //           ticker: 'ticker');
//   //   const NotificationDetails platformChannelSpecifics =
//   //       NotificationDetails(android: androidPlatformChannelSpecifics);
//   //   await flutterLocalNotificationsPlugin.show(
//   //       0, 'plain title', 'plain body', platformChannelSpecifics,
//   //       payload: 'item x');
//   // }

//   Future<void> _showFullScreenNotification() async {
//             await flutterLocalNotificationsPlugin.zonedSchedule(
//                   0,
//                   DateFormat('hh:mm').format(DateTime.now()),
//                   widget.comment,
//                   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),

//                   const NotificationDetails(
//                       android: AndroidNotificationDetails(
//                           'full screen channel id',
//                           'full screen channel name',
//                           'full screen channel description',
//                           priority: Priority.high,
//                           importance: Importance.high,
//                           fullScreenIntent: true,
//                           playSound: true,
//                           // showWhen: AlarmWindow.alarmTime,
//                           )
//                         ),
//                   androidAllowWhileIdle: true,
//                   uiLocalNotificationDateInterpretation:
//                       UILocalNotificationDateInterpretation.absoluteTime
//             );
//   }


//   Future<void> _showNotificationCustomSound() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your other channel id',
//       'your other channel name',
//       'your other channel description',
//       sound: RawResourceAndroidNotificationSound('slow_spring_board'),
//     );
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails(sound: 'slow_spring_board.aiff');
//     const MacOSNotificationDetails macOSPlatformChannelSpecifics =
//         MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//       macOS: macOSPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'custom sound notification title',
//       'custom sound notification body',
//       platformChannelSpecifics,
//     );
//   }


  

//   Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }


//   Future<String> _base64encodedImage(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     final String base64Data = base64Encode(response.bodyBytes);
//     return base64Data;
//   }

//   Future<Uint8List> _getByteArrayFromUrl(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     return response.bodyBytes;
//   }

  

//   Future<void> _cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

//   Future<void> _showOngoingNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'your channel id', 'your channel name', 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ongoing: true,
//             autoCancel: false);
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
//         'ongoing notification body', platformChannelSpecifics);
//   }

//   Future<void> _repeatNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('repeating channel id',
//             'repeating channel name', 'repeating description');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
//         'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
//         androidAllowWhileIdle: true);
//   }

//   Future<void> _createNotificationChannelGroup() async {
//     const String channelGroupId = 'your channel group id';
//     // create the group first
//     const AndroidNotificationChannelGroup androidNotificationChannelGroup =
//         AndroidNotificationChannelGroup(
//             channelGroupId, 'your channel group name',
//             description: 'your channel group description');
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .createNotificationChannelGroup(androidNotificationChannelGroup);

//     // create channels associated with the group
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .createNotificationChannel(const AndroidNotificationChannel(
//             'grouped channel id 1',
//             'grouped channel name 1',
//             'grouped channel description 1',
//             groupId: channelGroupId));

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .createNotificationChannel(const AndroidNotificationChannel(
//             'grouped channel id 2',
//             'grouped channel name 2',
//             'grouped channel description 2',
//             groupId: channelGroupId));

//     await showDialog<void>(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               content: Text('Channel group with name '
//                   '${androidNotificationChannelGroup.name} created'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             ));
//   }

//   Future<void> _deleteNotificationChannelGroup() async {
//     const String channelGroupId = 'your channel group id';
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.deleteNotificationChannelGroup(channelGroupId);

//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         content: const Text('Channel group with id $channelGroupId deleted'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel androidNotificationChannel =
//         AndroidNotificationChannel(
//       'your channel id 2',
//       'your channel name 2',
//       'your channel description 2',
//     );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidNotificationChannel);

//     await showDialog<void>(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               content:
//                   Text('Channel with name ${androidNotificationChannel.name} '
//                       'created'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             ));
//   }

//   Future<void> _deleteNotificationChannel() async {
//     const String channelId = 'your channel id 2';
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.deleteNotificationChannel(channelId);

//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         content: const Text('Channel with id $channelId deleted'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _getActiveNotifications() async {
//     final Widget activeNotificationsDialogContent =
//         await _getActiveNotificationsDialogContent();
//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         content: activeNotificationsDialogContent,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Widget> _getActiveNotificationsDialogContent() async {
//     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     if (!(androidInfo.version.sdkInt! >= 23)) {
//       return const Text(
//         '"getActiveNotifications" is available only for Android 6.0 or newer',
//       );
//     }

//     try {
//       final List<ActiveNotification>? activeNotifications =
//           await flutterLocalNotificationsPlugin
//               .resolvePlatformSpecificImplementation<
//                   AndroidFlutterLocalNotificationsPlugin>()!
//               .getActiveNotifications();

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text(
//             'Active Notifications',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const Divider(color: Colors.black),
//           if (activeNotifications!.isEmpty)
//             const Text('No active notifications'),
//           if (activeNotifications.isNotEmpty)
//             for (ActiveNotification activeNotification in activeNotifications)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'id: ${activeNotification.id}\n'
//                     'channelId: ${activeNotification.channelId}\n'
//                     'title: ${activeNotification.title}\n'
//                     'body: ${activeNotification.body}',
//                   ),
//                   const Divider(color: Colors.black),
//                 ],
//               ),
//         ],
//       );
//     } on PlatformException catch (error) {
//       return Text(
//         'Error calling "getActiveNotifications"\n'
//         'code: ${error.code}\n'
//         'message: ${error.message}',
//       );
//     }
//   }

//   Future<void> _getNotificationChannels() async {
//     final Widget notificationChannelsDialogContent =
//         await _getNotificationChannelsDialogContent();
//     await showDialog<void>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         content: notificationChannelsDialogContent,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Widget> _getNotificationChannelsDialogContent() async {
//     try {
//       final List<AndroidNotificationChannel>? channels =
//           await flutterLocalNotificationsPlugin
//               .resolvePlatformSpecificImplementation<
//                   AndroidFlutterLocalNotificationsPlugin>()!
//               .getNotificationChannels();

//       return Container(
//         width: double.maxFinite,
//         child: ListView(
//           children: <Widget>[
//             const Text(
//               'Notifications Channels',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const Divider(color: Colors.black),
//             if (channels?.isEmpty ?? true)
//               const Text('No notification channels')
//             else
//               for (AndroidNotificationChannel channel in channels!)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text('id: ${channel.id}\n'
//                         'name: ${channel.name}\n'
//                         'description: ${channel.description}\n'
//                         'groupId: ${channel.groupId}\n'
//                         'importance: ${channel.importance.value}\n'
//                         'playSound: ${channel.playSound}\n'
//                         'sound: ${channel.sound?.sound}\n'
//                         'enableVibration: ${channel.enableVibration}\n'
//                         'vibrationPattern: ${channel.vibrationPattern}\n'
//                         'showBadge: ${channel.showBadge}\n'
//                         'enableLights: ${channel.enableLights}\n'
//                         'ledColor: ${channel.ledColor}\n'),
//                     const Divider(color: Colors.black),
//                   ],
//                 ),
//           ],
//         ),
//       );
//     } on PlatformException catch (error) {
//       return Text(
//         'Error calling "getNotificationChannels"\n'
//         'code: ${error.code}\n'
//         'message: ${error.message}',
//       );
//     }
//   }
// }


// class _InfoValueString extends StatelessWidget {
//   const _InfoValueString({
//     required this.title,
//     required this.value,
//     Key? key,
//   }) : super(key: key);

//   final String title;
//   final Object? value;

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//         child: Text.rich(
//           TextSpan(
//             children: <InlineSpan>[
//               TextSpan(
//                 text: '$title ',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextSpan(
//                 text: '$value',
//               )
//             ],
//           ),
//         ),
//       );
// }
