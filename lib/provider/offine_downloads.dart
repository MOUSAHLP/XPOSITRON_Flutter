// import 'dart:async';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:delayed_widget/delayed_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:x_positron/mainpages/drawer.dart';
//  
// import 'package:x_positron/provider/introduction_dialog.dart';
// import 'banner_ad.dart';

// class OfflineDownloads extends StatefulWidget {
//   @override
//   _OfflineDownloadsState createState() => _OfflineDownloadsState();
// }

// class _OfflineDownloadsState extends State<OfflineDownloads>
//     with WidgetsBindingObserver {
//   ReceivePort _port = ReceivePort();
//   List<Map> downloadsListMaps = [];
//   bool isThereDownload = false;
//   int delaytime = 200;

//   @override
//   void initState() {
//     super.initState();
//     Change(6);
//     WidgetsBinding.instance!.addObserver(this);

//     checkIntro();

//     _bindBackgroundIsolate();
//     isThereDownloads();
//     FlutterDownloader.registerCallback(downloadCallback);
//   }

//   void _bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       _bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       var task = downloadsListMaps.where((element) => element['id'] == id);
//       task.forEach((element) {
//         element['progress'] = progress;
//         element['status'] = status;

//         isThereDownloads();
//         setState(() {});
//       });
//     });
//   }

//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send!.send([id, status, progress]);
//   }

//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }

//   Future task() async {
//     downloadsListMaps.clear();
//     List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
//     getTasks!.forEach((_task) {
//       Map _map = Map();
//       _map['status'] = _task.status;
//       _map['progress'] = _task.progress;
//       _map['id'] = _task.taskId;
//       _map['filename'] = _task.filename;
//       _map['savedDirectory'] = _task.savedDir;
//       downloadsListMaps.add(_map);
//     });
//     setState(() {});
//   }

//   isThereDownloads() async {
//     await task();
//     if (downloadsListMaps.length == 0) {
//       isThereDownload = true;
//     } else {
//       isThereDownload = false;
//     }
//     setState(() {});
//   }

//   filename(String _filename) {
//     var index = _filename.indexOf("X");
//     _filename = _filename.replaceRange(index - 1, _filename.length, "");
//     return _filename;
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     appLifecycleState(state);

//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _unbindBackgroundIsolate();

//     WidgetsBinding.instance!.removeObserver(this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime pre_backpress = DateTime.now();

//     Size size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () async {
//         final timegap = DateTime.now().difference(pre_backpress);
//         final cantExit = timegap >= Duration(seconds: 2);
//         pre_backpress = DateTime.now();
//         if (cantExit) {
//           //show snackbar
//           final snack = SnackBar(
//             content: Text(
//               "أضغط مرة أخرى للخروج",
//               textAlign: TextAlign.center,
//             ),
//             duration: Duration(seconds: 2),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snack);
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: AdBanner(),
//         drawer: Mydrawer(),
//         appBar: AppBar(
//           title: Text('تحميلاتي'),
//           actions: [
//             Container(
//                 margin: EdgeInsets.only(right: 10),
//                 child: IconButton(
//                     onPressed: () {
//                       showdialog(context, "تحميلاتي", intro());
//                     },
//                     icon: FaIcon(FontAwesomeIcons.questionCircle))),
//             PopupMenuButton(
//                 offset: Offset(10.0, 60.0),
//                 tooltip: "خيارات متقدمة",
//                 color: Colors.white,
//                 enableFeedback: true,
//                 itemBuilder: (context) => [
//                       PopupMenuItem(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Colors.green,
//                                     Colors.white,
//                                   ],
//                                   stops: [
//                                     0.2,
//                                     1
//                                   ])),
//                           child: ListTile(
//                             title: Row(
//                               children: [
//                                 Icon(
//                                   Icons.play_arrow,
//                                   color: Colors.black,
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "أستئناف الكل",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         onTap: () async {
//                           List<Map> puseddownloads = [];
//                           for (int i = 0; i < downloadsListMaps.length; i++) {
//                             if (downloadsListMaps[i]["status"] ==
//                                 DownloadTaskStatus.paused) {
//                               Map _map = {};
//                               _map["id"] = downloadsListMaps[i]["id"];
//                               _map["status"] = downloadsListMaps[i]["status"];
//                               puseddownloads.add(_map);
//                             }
//                           }
//                           if (downloadsListMaps.length != 0) {
//                             for (int i = 0; i < puseddownloads.length; i++) {
//                               if (puseddownloads[i]["status"] ==
//                                   DownloadTaskStatus.paused) {
//                                 FlutterDownloader.resume(
//                                         taskId: puseddownloads[i]["id"])
//                                     .then((newTaskID) {
//                                   downloadsListMaps.forEach((element) {
//                                     if (element["id"] ==
//                                         puseddownloads[i]["id"]) {
//                                       changeTaskID(element["id"], newTaskID!);
//                                     }
//                                   });
//                                 });
//                                 task();
//                               }
//                             }
//                           }
//                         },
//                       ),
//                       PopupMenuItem(
//                         child: Container(
//                           margin: EdgeInsets.only(top: 10, bottom: 10),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Colors.blue,
//                                     Colors.white,
//                                   ],
//                                   stops: [
//                                     0.2,
//                                     1
//                                   ])),
//                           child: ListTile(
//                             title: Row(
//                               children: [
//                                 Icon(
//                                   Icons.pause,
//                                   color: Colors.black,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "أيقاف الكل",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         onTap: () async {
//                           List<Map> runningdownloads = [];
//                           for (int i = 0; i < downloadsListMaps.length; i++) {
//                             if (downloadsListMaps[i]["status"] ==
//                                 DownloadTaskStatus.running) {
//                               Map _map = {};
//                               _map["id"] = downloadsListMaps[i]["id"];
//                               _map["status"] = downloadsListMaps[i]["status"];
//                               runningdownloads.add(_map);
//                             }
//                           }
//                           if (downloadsListMaps.length != 0) {
//                             for (int i = 0; i < runningdownloads.length; i++) {
//                               if (runningdownloads[i]["status"] ==
//                                   DownloadTaskStatus.running) {
//                                 FlutterDownloader.pause(
//                                     taskId: runningdownloads[i]["id"]);

//                                 task();
//                               }
//                             }
//                           }
//                         },
//                       ),
//                       PopupMenuItem(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Colors.red,
//                                     Colors.white,
//                                   ],
//                                   stops: [
//                                     0.2,
//                                     1
//                                   ])),
//                           child: ListTile(
//                             title: Row(
//                               children: [
//                                 Icon(
//                                   Icons.close,
//                                   color: Colors.black,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "الغاء الكل",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         onTap: () {
//                           FlutterDownloader.cancelAll();
//                         },
//                       ),
//                     ]),
//           ],
//         ),
//         body: isThereDownload
//             ? Container(
//                 margin: EdgeInsets.only(top: size.height / 8),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "لا يوجد تحميلات بعد",
//                         style: TextStyle(fontSize: 30, color: Colors.grey),
//                       ),
//                       FaIcon(
//                         FontAwesomeIcons.smile,
//                         color: Colors.grey,
//                         size: 60,
//                       ),
//                     ],
//                   ),
//                 ))
//             : Container(
//                 child: ListView.builder(
//                   itemCount: downloadsListMaps.length,
//                   itemBuilder: (BuildContext context, int i) {
//                     Map _map =
//                         downloadsListMaps[downloadsListMaps.length - 1 - i];
//                     String _filename = _map['filename'];
//                     int _progress = _map['progress'];
//                     DownloadTaskStatus _status = _map['status'];
//                     String _id = _map['id'];
//                     String _savedDirectory = _map['savedDirectory'];

//                     if (delaytime < 700) {
//                       delaytime += 100;
//                     }
//                     return DelayedWidget(
//                       delayDuration: Duration(milliseconds: delaytime),
//                       animationDuration: Duration(milliseconds: 300),
//                       animation: DelayedAnimations.SLIDE_FROM_RIGHT,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (_status == DownloadTaskStatus.complete) {
//                             FlutterDownloader.open(taskId: _id);
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: _status == DownloadTaskStatus.canceled
//                                     ? [
//                                         Colors.red,
//                                         Colors.white,
//                                       ]
//                                     : _status == DownloadTaskStatus.complete
//                                         ? [
//                                             Colors.green.shade600,
//                                             Colors.white,
//                                           ]
//                                         : _status == DownloadTaskStatus.failed
//                                             ? [
//                                                 Colors.red.shade600,
//                                                 Colors.white,
//                                               ]
//                                             : _status ==
//                                                     DownloadTaskStatus.paused
//                                                 ? [Colors.blue, Colors.white]
//                                                 : _status ==
//                                                         DownloadTaskStatus
//                                                             .running
//                                                     ? [
//                                                         Colors.blue,
//                                                         Colors.white
//                                                       ]
//                                                     : [
//                                                         Colors.blue,
//                                                         Colors.white
//                                                       ],
//                                 stops: [0.2, 1]),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               ListTile(
//                                 isThreeLine: false,
//                                 title: Text("${filename(_filename)}",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 24)),
//                                 subtitle: downloadStatus(_status),
//                                 trailing: SizedBox(
//                                   child: buttons(_status, _id, i),
//                                   width: 60,
//                                 ),
//                               ),
//                               (_status == DownloadTaskStatus.running ||
//                                           _status ==
//                                               DownloadTaskStatus.paused) &&
//                                       _progress > 0
//                                   ? Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Text('$_progress%',
//                                               style: TextStyle(
//                                                   color: Colors.green)),
//                                           Row(
//                                             children: <Widget>[
//                                               Expanded(
//                                                 child: LinearProgressIndicator(
//                                                   color: Colors.green,
//                                                   backgroundColor:
//                                                       Colors.green[200],
//                                                   value: _progress / 100,
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     )
//                                   : Text(""),
//                               SizedBox(height: 10)
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget downloadStatus(DownloadTaskStatus _status) {
//     return _status == DownloadTaskStatus.canceled
//         ? Text('تم الغاؤه', style: TextStyle(color: Colors.white, fontSize: 16))
//         : _status == DownloadTaskStatus.complete
//             ? Text('تم تحميله ( أنقر للفتح )',
//                 style: TextStyle(color: Colors.white, fontSize: 16))
//             : _status == DownloadTaskStatus.failed
//                 ? Text('فشل التحميل',
//                     style: TextStyle(color: Colors.white, fontSize: 16))
//                 : _status == DownloadTaskStatus.paused
//                     ? Text('تم ايقافه',
//                         style: TextStyle(color: Colors.white, fontSize: 16))
//                     : _status == DownloadTaskStatus.running
//                         ? Text('يتم التحميل',
//                             style: TextStyle(color: Colors.white, fontSize: 16))
//                         : Text('يرجى الأنتظار',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 16));
//   }

//   Widget buttons(DownloadTaskStatus _status, String taskid, int index) {
//     return _status == DownloadTaskStatus.canceled
//         ? Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 child: Icon(Icons.cached, size: 30, color: Colors.green),
//                 onTap: () {
//                   FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
//                     changeTaskID(taskid, newTaskID!);
//                   });
//                   task();
//                 },
//               ),
//               GestureDetector(
//                 child: Icon(Icons.delete, size: 30, color: Colors.red),
//                 onTap: () async {
//                   downloadsListMaps
//                       .removeAt(downloadsListMaps.length - 1 - index);
//                   FlutterDownloader.remove(
//                       taskId: taskid, shouldDeleteContent: true);
//                   await isThereDownloads();

//                   setState(() {});
//                 },
//               )
//             ],
//           )
//         : _status == DownloadTaskStatus.failed
//             ? Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     child: Icon(Icons.cached, size: 30, color: Colors.green),
//                     onTap: () {
//                       FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
//                         changeTaskID(taskid, newTaskID!);
//                       });
//                       task();

//                       setState(() {});
//                     },
//                   ),
//                   GestureDetector(
//                     child: Icon(Icons.delete, size: 30, color: Colors.red),
//                     onTap: () async {
//                       downloadsListMaps
//                           .removeAt(downloadsListMaps.length - 1 - index);
//                       FlutterDownloader.remove(
//                           taskId: taskid, shouldDeleteContent: true);
//                       await isThereDownloads();

//                       setState(() {});
//                     },
//                   )
//                 ],
//               )
//             : _status == DownloadTaskStatus.paused
//                 ? Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       GestureDetector(
//                         child: Icon(Icons.play_arrow,
//                             size: 30, color: Colors.blue),
//                         onTap: () {
//                           FlutterDownloader.resume(taskId: taskid).then(
//                             (newTaskID) => changeTaskID(taskid, newTaskID!),
//                           );
//                           task();
//                         },
//                       ),
//                       GestureDetector(
//                         child: Icon(Icons.close, size: 30, color: Colors.red),
//                         onTap: () {
//                           FlutterDownloader.cancel(taskId: taskid);
//                         },
//                       )
//                     ],
//                   )
//                 : _status == DownloadTaskStatus.running
//                     ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           GestureDetector(
//                             child: Icon(Icons.pause,
//                                 size: 30, color: Colors.green),
//                             onTap: () {
//                               FlutterDownloader.pause(taskId: taskid);
//                             },
//                           ),
//                           GestureDetector(
//                             child:
//                                 Icon(Icons.close, size: 30, color: Colors.red),
//                             onTap: () {
//                               FlutterDownloader.cancel(taskId: taskid);
//                             },
//                           )
//                         ],
//                       )
//                     : _status == DownloadTaskStatus.complete
//                         ? GestureDetector(
//                             child:
//                                 Icon(Icons.delete, size: 50, color: Colors.red),
//                             onTap: () async {
//                               try {
//                                 await AwesomeDialog(
//                                   context: context,
//                                   dialogType: DialogType.QUESTION,
//                                   animType: AnimType.SCALE,
//                                   title: 'حذف الملف',
//                                   body: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "هل تريد حذف هذا الملف ؟",
//                                         style: TextStyle(fontSize: 20),
//                                       ),
//                                       Text("(سيحذف هذا الملف من جهازك)",
//                                           style: TextStyle(fontSize: 18))
//                                     ],
//                                   ),
//                                   btnCancelText: "الغاء",
//                                   btnCancelOnPress: () {},
//                                   btnOkText: "حذف",
//                                   btnOkOnPress: () async {
//                                     downloadsListMaps.removeAt(
//                                         downloadsListMaps.length - 1 - index);
//                                     FlutterDownloader.remove(
//                                         taskId: taskid,
//                                         shouldDeleteContent: true);
//                                     await isThereDownloads();

//                                     setState(() {});
//                                   },
//                                 ).show();
//                               } catch (e) {}
//                             },
//                           )
//                         : Container();
//   }

//   Future changeTaskID(String taskid, String newTaskID) async {
//     Map? task = downloadsListMaps.firstWhere(
//       (element) => element['taskId'] == taskid,
//     );
//     task['taskId'] = newTaskID;
//     downloadsListMaps.clear();
//     List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
//     getTasks!.forEach((_task) {
//       Map _map = Map();
//       _map['status'] = _task.status;
//       _map['progress'] = _task.progress;
//       _map['id'] = _task.taskId;
//       _map['filename'] = _task.filename;
//       _map['savedDirectory'] = _task.savedDir;
//       downloadsListMaps.add(_map);
//     });
//     setState(() {});
//   }

//   intro() {
//     return IntroductionScreen(
//       globalBackgroundColor: Colors.white,
//       pages: [
//         PageViewModel(
//           titleWidget: Container(
//             height: 250,
//             child: Image.asset(
//               "images/Mydownloads1.png",
//               fit: BoxFit.fitHeight,
//             ),
//           ),
//           bodyWidget: Container(),
//           footer: Column(
//             children: [
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 400),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Text(
//                     "يمكنك التحكم بجميع"
//                     "\n"
//                     " تحميلاتك من هنا",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 700),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("أيقاف التحميل مؤقتا _ ",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 900),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("أستئناف التحميل  _ ",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 1000),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("الغاء التحميل  _ ",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 1100),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text(" أعادة بدء التحميل من جديد _ ",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 1100),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text(" فتح الملف الذي تم تحميله _ ",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         PageViewModel(
//           titleWidget: Image.asset(
//             "images/Mydownloads2.png",
//           ),
//           bodyWidget: Column(
//             children: [
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 400),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Text(": يمكنك ",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 700),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("أستئناف كل التحميلات _",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 900),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("أيقاف كل التحميلات _",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 1000),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Container(
//                   width: double.infinity,
//                   child: Text("الغاء كل التحميلات _",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         PageViewModel(
//           titleWidget: Image.asset(
//             "images/Mydownloads3.png",
//           ),
//           bodyWidget: Text(""),
//           footer: Column(
//             children: [
//               DelayedWidget(
//                 delayDuration: Duration(milliseconds: 400),
//                 animationDuration: Duration(milliseconds: 700),
//                 animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
//                 child: Text(
//                     "ملاحظة : سيتم حذف الملف من جهازك ايضا ان قمت بحذفه هنا",
//                     textAlign: TextAlign.right,
//                     style: TextStyle(fontSize: 18, color: Color(0xff909295))),
//               ),
//             ],
//           ),
//         ),
//       ],
//       onDone: () async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool("offlineIntro", true);
//         Navigator.of(context).pop();
//       },
//       done: Text("فهمت",
//           style: TextStyle(
//             fontSize: 20,
//           )),
//       showNextButton: true,
//       next: Text("التالي",
//           style: TextStyle(
//             fontSize: 20,
//           )),
//       animationDuration: 700,
//       curve: Curves.easeOut,
//     );
//   }

//   checkIntro() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var check = await prefs.getBool("offlineIntro") ?? false;
//     if (check == false) {
//       WidgetsBinding.instance!.addPostFrameCallback((_) async {
//         showdialog(context, "تحميلاتي", intro());
//       });
//     }
//   }
// }
