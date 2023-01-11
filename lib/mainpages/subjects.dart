import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_positron/mainpages/explain.dart';

import 'package:x_positron/provider/connectivity.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/offline.dart';
import 'package:x_positron/provider/online_downloads.dart';
import 'package:x_positron/provider/refresh.dart';
import 'package:x_positron/provider/skeleton.dart';
import 'package:x_positron/provider/subjects_info.dart';
import 'dart:ui';

//https://github.com/themaaz32/download_teach

// import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class Subjects extends StatefulWidget {
  final subject;
  final arabSubject;
  final year;
  final sumester;
  final explain;
  final isauto;
  final iswork;
  const Subjects(
      {Key? key,
      this.subject,
      this.arabSubject,
      this.explain,
      this.isauto,
      this.iswork,
      this.sumester,
      this.year})
      : super(key: key);
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> with WidgetsBindingObserver {
  var _loveslider = 1.0;
  var _hardslider = 1.0;
  bool favorite = false;
  Icon favorite_change(var fav) {
    if (fav == false || fav == null) {
      return Icon(Icons.favorite_border_rounded, color: Colors.white, size: 30);
    } else {
      return Icon(Icons.favorite, color: Colors.red, size: 30);
    }
  }

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  var likes;
  var love_precentage = 0.0;
  var love_precentage_center = 0.0;
  var hard_precentage = 0.0;
  var hard_precentage_center = 0.0;
  var isliked;
  var userlove;
  var userhard;
  var id;
  Future statistics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = await prefs.getString("id");
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/statistics_flutter.php");

      var response = await http.post(url, body: {
        "user_id": id,
        "subject": "${widget.subject}",
        "arab-name": "${widget.arabSubject}"
      });
      var responsebody = jsonDecode(response.body);

      if (responsebody['subject'] == '${widget.subject}') {
        likes = responsebody['likes'];
        love_precentage = responsebody['love_precentage'] / 1.0;
        love_precentage_center = responsebody['love_precentage_center'] / 1.0;
        hard_precentage = responsebody['hard_precentage'] / 1.0;
        hard_precentage_center = responsebody['hard_precentage_center'] / 1.0;
        isliked = responsebody['isliked'];
        userlove = responsebody['userlove'];
        userhard = responsebody['userhard'];

        if (userlove != null) {
          _loveslider = userlove / 1.0;
        }
        if (userhard != null) {
          _hardslider = userhard / 1.0;
        }
        if (isliked == 0) {
          favorite = false;
        } else if (isliked == 1) {
          favorite = true;
        }
      }

      setState(() {});
    } catch (e) {
      try {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'خطأ',
          desc:
              'حدث خطأ ما\n يرجى التأكد من أتصالك بالأنترنت\n و المحاولة مجددا',
          btnOkText: "أعادة محاولة",
          btnOkOnPress: () {},
        ).show();
      } catch (e) {}
    }
  }

  var sliderindecatorlike;
  var sliderindecatorlove;
  var sliderindecatorhard;

  Future slider(var rate, var rateval) async {
    try {
      setState(() {
        if (rate == "like") {
          sliderindecatorlike = true;
        }
        if (rate == "love") {
          sliderindecatorlove = true;
        }
        if (rate == "hard") {
          sliderindecatorhard = true;
        }
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = await prefs.getString("id");
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/user_statistics_flutter.php");

      var response = await http.post(url, body: {
        "user_id": id,
        "subject": "${widget.subject}",
        "arab-name": "${widget.arabSubject}",
        "$rate": "$rateval"
      });

      var responsebody = await jsonDecode(response.body);

      if (responsebody['succeeded'] == "done") {
        if (rate == "love") {
          _loveslider = rateval;
        } else if (rate == "hard") {
          _hardslider = rateval;
        }
      }
    } catch (m) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: 'خطأ',
        desc: 'حدث خطأ ما\n يرجى التأكد من أتصالك بالأنترنت\n و المحاولة مجددا',
        btnOkText: "أعادة محاولة",
        btnOkOnPress: () {
          Navigator.of(context).pushReplacementNamed("first");
        },
      ).show();
    }

    sliderindecatorlike = false;
    sliderindecatorlove = false;
    sliderindecatorhard = false;

    statistics();
  }

  addToLastVisited() async {
    Provider.of<SubjectsInfo>(context, listen: false)
        .vistedSubjectsfun(widget.subject, int.parse(widget.year));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    addToLastVisited();

    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      statistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showdialog(context, "المواد", intro());
                          },
                          icon: FaIcon(FontAwesomeIcons.questionCircle)),
                      sliderindecatorlike == true
                          ? Atom(
                              size: 30,
                              nucleusRadiusFactor: 2,
                              orbitsColor: Colors.white,
                              nucleusColor: Colors.white,
                              electronsColor: Colors.white,
                              orbit1Angle: (0),
                              orbit2Angle: (3.14 / 3),
                              orbit3Angle: (3.14 / -3),
                              animDuration1: Duration(milliseconds: 1000),
                              animDuration2: Duration(milliseconds: 1300),
                              animDuration3: Duration(milliseconds: 800),
                            )
                          : Text(""),
                      IconButton(
                          onPressed: () {
                            if (favorite == false) {
                              favorite = true;

                              slider("like", 1);
                            } else {
                              favorite = false;
                              slider("like", 0);
                            }
                          },
                          icon: favorite_change(favorite)),
                    ],
                  ),
                )
              ],
              title: AutoSizeText("${widget.arabSubject}",
                  maxLines: 1,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              bottom: TabBar(
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: AutoSizeText("الشرح",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: AutoSizeText("روابط التحميل",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: AutoSizeText("الأحصائيات",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                //1
                Explain(
                  arabSubject: widget.arabSubject,
                  subject: widget.subject,
                  isauto: widget.isauto,
                  iswork: widget.iswork,
                  year: widget.year,
                  sumester: widget.sumester,
                  explain: widget.explain,
                ),
                //2
                OnlineDownload(
                  subject: "${widget.subject}",
                  year: widget.year,
                ),
                //3
                Consumer<ConnectivityProvider>(
                    builder: (context, online, child) {
                  if (online.isOnline == false) {
                    return Offline();
                  }
                  if (online.isOnline == true) {
                    return likes == null
                        ? RefreshWidget(
                            keyRefresh: keyRefresh,
                            onRefresh: statistics,
                            child: statisticsSkeleton())
                        : RefreshWidget(
                            keyRefresh: keyRefresh,
                            onRefresh: statistics,
                            child: Container(
                              color: Colors.white,
                              child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListView(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xffc8c8c8),
                                                    spreadRadius: 2,
                                                    offset: Offset(5, 10),
                                                    blurRadius: 5)
                                              ]),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 0),
                                                    alignment: Alignment(1, 0),
                                                    child: AutoSizeText(
                                                        "عدد الأعجابات : ",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        AutoSizeText("$likes",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .red)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: width > 400
                                                          ? 140
                                                          : 100,
                                                      lineWidth:
                                                          width > 400 ? 20 : 15,
                                                      animation: true,
                                                      animationDuration: 3000,
                                                      curve: Curves.easeInOut,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      percent: love_precentage
                                                          .toDouble(),
                                                      progressColor:
                                                          Colors.blue,
                                                      center: AutoSizeText(
                                                          "${double.parse((love_precentage_center.toDouble()).toStringAsFixed(1))}%",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                      footer: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: AutoSizeText(
                                                            "نسبة حب المادة  ",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width < 330
                                                                        ? 16
                                                                        : 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: width > 400
                                                          ? 140
                                                          : 100,
                                                      lineWidth:
                                                          width > 400 ? 20 : 15,
                                                      animation: true,
                                                      animationDuration: 3000,
                                                      curve: Curves.easeInOut,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      percent: hard_precentage
                                                          .toDouble(),
                                                      progressColor:
                                                          Colors.green,
                                                      center: AutoSizeText(
                                                          "${double.parse((hard_precentage_center.toDouble()).toStringAsFixed(1))}%",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                      footer: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: AutoSizeText(
                                                            "نسبة صعوبة المادة  ",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width < 330
                                                                        ? 16
                                                                        : 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                            right: 20,
                                            bottom: 20),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xffc8c8c8),
                                                  spreadRadius: 2,
                                                  offset: Offset(5, 10),
                                                  blurRadius: 5)
                                            ]),
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    child: AutoSizeText(
                                                        "حدد نسبة حبك للمادة  : ",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: width <
                                                                    330
                                                                ? 16
                                                                : width > 400
                                                                    ? 22
                                                                    : 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: Container(
                                                    width: 300,
                                                    height: width < 330
                                                        ? 30
                                                        : width > 400
                                                            ? 70
                                                            : 50,
                                                    child: Slider.adaptive(
                                                      value: _loveslider,
                                                      divisions: 10,
                                                      label:
                                                          "${_loveslider.toInt()}",
                                                      max: 10,
                                                      min: 0,
                                                      onChanged: (i) {
                                                        setState(() {
                                                          _loveslider = i;
                                                        });
                                                      },
                                                      onChangeEnd: (val) {
                                                        slider("love", val);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                userlove != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          AutoSizeText(
                                                            "تقييمك :",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20),
                                                          ),
                                                          AutoSizeText(
                                                            " ${_loveslider.toInt()}/10",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          sliderindecatorlove ==
                                                                  true
                                                              ? SizedBox(
                                                                  width: 20,
                                                                )
                                                              : Text(""),
                                                          sliderindecatorlove ==
                                                                  true
                                                              ? Atom(
                                                                  size: width <
                                                                          330
                                                                      ? 25
                                                                      : width >
                                                                              400
                                                                          ? 32
                                                                          : 30,
                                                                  nucleusRadiusFactor:
                                                                      2,
                                                                  orbitsColor:
                                                                      Colors
                                                                          .blue,
                                                                  nucleusColor:
                                                                      Colors
                                                                          .blue,
                                                                  electronsColor:
                                                                      Colors
                                                                          .blue,
                                                                  orbit1Angle:
                                                                      (0),
                                                                  orbit2Angle:
                                                                      (3.14 /
                                                                          3),
                                                                  orbit3Angle:
                                                                      (3.14 /
                                                                          -3),
                                                                  animDuration1:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  animDuration2:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1300),
                                                                  animDuration3:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                )
                                                              : Text(""),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          AutoSizeText(
                                                            "لم تقيم بعد",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          sliderindecatorlove ==
                                                                  true
                                                              ? Atom(
                                                                  size: width <
                                                                          330
                                                                      ? 25
                                                                      : 30,
                                                                  nucleusRadiusFactor:
                                                                      2,
                                                                  orbitsColor:
                                                                      Colors
                                                                          .blue,
                                                                  nucleusColor:
                                                                      Colors
                                                                          .blue,
                                                                  electronsColor:
                                                                      Colors
                                                                          .blue,
                                                                  orbit1Angle:
                                                                      (0),
                                                                  orbit2Angle:
                                                                      (3.14 /
                                                                          3),
                                                                  orbit3Angle:
                                                                      (3.14 /
                                                                          -3),
                                                                  animDuration1:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  animDuration2:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1300),
                                                                  animDuration3:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                )
                                                              : Text(""),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                    child: AutoSizeText(
                                                        "حدد نسبة صعوبة المادة بالنسبة اليك  : ",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: width <
                                                                    330
                                                                ? 16
                                                                : width > 400
                                                                    ? 22
                                                                    : 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                Directionality(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    child: Container(
                                                      width: 300,
                                                      height: width < 330
                                                          ? 30
                                                          : width > 400
                                                              ? 70
                                                              : 50,
                                                      child: SliderTheme(
                                                        data: SliderThemeData(
                                                            valueIndicatorTextStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            valueIndicatorColor:
                                                                Colors.green),
                                                        child: Slider(
                                                          value: _hardslider,
                                                          activeColor:
                                                              Colors.green,
                                                          inactiveColor:
                                                              Colors.green[100],
                                                          divisions: 10,
                                                          label:
                                                              "${_hardslider.toInt()}",
                                                          max: 10,
                                                          min: 0,
                                                          onChanged: (i) {
                                                            setState(() {
                                                              _hardslider = i;
                                                            });
                                                          },
                                                          onChangeEnd: (val) {
                                                            slider("hard", val);
                                                          },
                                                        ),
                                                      ),
                                                    )),
                                                userhard != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "تقييمك :",
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20),
                                                          ),
                                                          Text(
                                                            " ${_hardslider.toInt()}/10",
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20,
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          sliderindecatorhard ==
                                                                  true
                                                              ? SizedBox(
                                                                  width: 20,
                                                                )
                                                              : Text(""),
                                                          sliderindecatorhard ==
                                                                  true
                                                              ? Atom(
                                                                  size: width <
                                                                          330
                                                                      ? 25
                                                                      : width >
                                                                              400
                                                                          ? 32
                                                                          : 30,
                                                                  nucleusRadiusFactor:
                                                                      2,
                                                                  orbitsColor:
                                                                      Colors
                                                                          .green,
                                                                  nucleusColor:
                                                                      Colors
                                                                          .green,
                                                                  electronsColor:
                                                                      Colors
                                                                          .green,
                                                                  orbit1Angle:
                                                                      (0),
                                                                  orbit2Angle:
                                                                      (3.14 /
                                                                          3),
                                                                  orbit3Angle:
                                                                      (3.14 /
                                                                          -3),
                                                                  animDuration1:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  animDuration2:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1300),
                                                                  animDuration3:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                )
                                                              : Text(""),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "لم تقيم بعد",
                                                            style: TextStyle(
                                                                fontSize: width <
                                                                        330
                                                                    ? 16
                                                                    : width >
                                                                            400
                                                                        ? 22
                                                                        : 20,
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          sliderindecatorhard ==
                                                                  true
                                                              ? Atom(
                                                                  size: width <
                                                                          330
                                                                      ? 25
                                                                      : width >
                                                                              400
                                                                          ? 32
                                                                          : 30,
                                                                  nucleusRadiusFactor:
                                                                      2,
                                                                  orbitsColor:
                                                                      Colors
                                                                          .green,
                                                                  nucleusColor:
                                                                      Colors
                                                                          .green,
                                                                  electronsColor:
                                                                      Colors
                                                                          .green,
                                                                  orbit1Angle:
                                                                      (0),
                                                                  orbit2Angle:
                                                                      (3.14 /
                                                                          3),
                                                                  orbit3Angle:
                                                                      (3.14 /
                                                                          -3),
                                                                  animDuration1:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                  animDuration2:
                                                                      Duration(
                                                                          milliseconds:
                                                                              1300),
                                                                  animDuration3:
                                                                      Duration(
                                                                          milliseconds:
                                                                              800),
                                                                )
                                                              : Text(""),
                                                        ],
                                                      )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                  }

                  return statisticsSkeleton();
                })
              ],
            )));
  }

  intro() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double responsiveFont = width < 330 ? 16 : 20;

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Image.asset(
            "images/Subject1.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText(": تجد في تبويبة الشرح",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(fontSize: 18, color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 900),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("شرح عن المادة _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1000),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(" خصائص المادة _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1100),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        "\n"
                        "سجل أعجابك بالمادة بأيقونة القلب بالأعلى",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Subject2.png",
            height: height * .4,
          ),
          bodyWidget: Text(""),
          footer: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("جميع مجلدات و ملفات المادة",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("مع المعلومات الخاصة بكل مجلد",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Subject3.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Text(": تجد في تبويبة روابط التحميل",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("ملفات هذه المادة  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1000),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        "معلومات عن الملفات  _"
                        "\n"
                        "(نوعه , حجمه , سنة اخر تحديث)",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Subject4.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        " أختر متصفح للانتقال الى صفحة الويب التي ستحمل منها الملف ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Subject5.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        "ملاحظة اذا طلعتلك هذه الواجهة أنقر على (التنزيل على أي حال) وسيتم تحميل الملف"
                        "\n"
                        "هذه اجراءات من سياسة غوغل للحماية (لان الملف كبير غالبا)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/subject6.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Text(": في تبويبة الأحصائيات تجد",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(" عدد الأعجابات _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 900),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("نسبة حب المادة  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1000),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text("نسبة صعوبة المادة  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1100),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        "\n"
                        "ولتضع تقييمك الخاص",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onDone: () async {
        Navigator.of(context).pop();
      },
      dotsDecorator: DotsDecorator(size: Size.square(6)),
      done: AutoSizeText("فهمت",
          maxLines: 1,
          style: TextStyle(
            fontSize: 15,
          )),
      dotsFlex: width > 400 ? 2 : 3,
      showNextButton: true,
      next: AutoSizeText("التالي",
          maxLines: 1,
          style: TextStyle(
            fontSize: 15,
          )),
      animationDuration: 700,
      curve: Curves.easeOut,
    );
  }
}
