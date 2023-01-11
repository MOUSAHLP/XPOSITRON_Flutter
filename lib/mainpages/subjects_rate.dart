import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:x_positron/mainpages/subjects.dart';
import 'package:x_positron/provider/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/offline.dart';
import 'package:x_positron/provider/refresh.dart';
import 'package:x_positron/provider/skeleton.dart';

class SubjectsRate extends StatefulWidget {
  const SubjectsRate({Key? key}) : super(key: key);

  @override
  _SubjectsRateState createState() => _SubjectsRateState();
}

class _SubjectsRateState extends State<SubjectsRate>
    with WidgetsBindingObserver {
  static Map<String, dynamic> posts = Map();
  static Map<String, dynamic> finalMap = {};

  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  int delaytime = 200;
  String filter = "loves";
  Future subjects() async {
    try {
      final url =
          Uri.parse("https://xpositron.000webhostapp.com/flutter/subjects.php");

      var response = await http.post(url, body: {
        "subject": "sub",
      });
      var responsebody = jsonDecode(response.body);
      posts.addAll(responsebody);
      votedFilter(yearFilterColor);
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
          btnOkOnPress: () {
            Navigator.of(context).pushReplacementNamed("subjects");
          },
        ).show();
      } catch (e) {}
    }
  }

  setTopColors(int i) {
    if (i == 0) {
      return Color(0xffffd700);
    } else if (i == 1) {
      return Color(0xffc0c0c0);
    } else if (i == 2) {
      return Color(0xffcd7f32);
    } else {
      return Color(0xff909295);
    }
  }

  votedFilter(year) {
    switch (year) {
      case 0:
        finalMap.addAll(posts);
        break;
      default:
        finalMap["likes"] = subjectFilter(year, "likes");
        finalMap["loves"] = subjectFilter(year, "loves");
        finalMap["hards"] = subjectFilter(year, "hards");
        break;
    }
  }

  int yearFilterColor = 0;
  subjectFilter(year, filterfun) {
    List _list = posts["$filterfun"];
    List _finalList = [];
    _list.forEach((element) {
      if (element["year"] == "$year") {
        _finalList.add(element);
      }
    });
    _finalList.forEach((ele) {});
    return _finalList;
  }

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    Change(6);

    if (online.isOnline == null || online.isOnline) {
      subjects();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            final snack = SnackBar(
              content: Text(
                "أضغط مرة أخرى للخروج",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: AutoSizeText("المواد الأكثر تقييما",
                  maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold)),
              bottomOpacity: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      showdialog(context, "المواد الأكثر تقييما", intro());
                    },
                    icon: FaIcon(FontAwesomeIcons.questionCircle)),
                PopupMenuButton(
                  offset: Offset(10.0, 60.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Icon(Icons.filter_list_rounded, color: Colors.white),
                        Text("فرز على حسب",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                  tooltip: "فرز على حسب ",
                  color: Colors.white,
                  enableFeedback: true,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          ": فرز على حسب ",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      enabled: false,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: filter == "hards"
                                      ? Colors.green[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: AutoSizeText(
                                "نسبة\n صعوبة المادة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "hards"
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "hards";

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: filter == "likes"
                                      ? Colors.red[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: AutoSizeText(
                                "عدد\n الأعجابات",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "likes"
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "likes";

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: filter == "loves"
                                      ? Colors.blue[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: AutoSizeText(
                                "نسبة\n حب المادة",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "loves"
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "loves";

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Divider(height: 2, color: Colors.black),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          " : الفلاتر",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                        child: Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            decoration: BoxDecoration(
                                color: yearFilterColor == 1
                                    ? Colors.blue[50]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.looks_one_rounded,
                                    color: yearFilterColor == 1
                                        ? Colors.blue
                                        : Colors.black45,
                                  ),
                                  Container(
                                    height: 40,
                                    child: AutoSizeText(
                                      "السنة الأولى فقط",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: yearFilterColor == 1
                                            ? Colors.blue
                                            : Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                yearFilterColor = 1;
                                finalMap.clear();
                                finalMap["likes"] = subjectFilter(1, "likes");
                                finalMap["loves"] = subjectFilter(1, "loves");
                                finalMap["hards"] = subjectFilter(1, "hards");
                                Navigator.of(context).pop();

                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 110,
                            decoration: BoxDecoration(
                                color: yearFilterColor == 0
                                    ? Colors.blue[50]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.chartLine,
                                    color: yearFilterColor == 0
                                        ? Colors.blue
                                        : Colors.black45,
                                  ),
                                  Container(
                                    height: 40,
                                    child: AutoSizeText(
                                      "كل المواد ",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: yearFilterColor == 0
                                            ? Colors.blue
                                            : Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                yearFilterColor = 0;
                                finalMap.clear();
                                finalMap.addAll(posts);
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                    PopupMenuItem(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            child: Row(
                              children: [
                                Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: yearFilterColor == 3
                                          ? Colors.blue[50]
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.looks_3_rounded,
                                          color: yearFilterColor == 3
                                              ? Colors.blue
                                              : Colors.black45,
                                        ),
                                        Container(
                                          height: 40,
                                          child: AutoSizeText(
                                            "السنة الثالثة فقط",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: yearFilterColor == 3
                                                  ? Colors.blue
                                                  : Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      yearFilterColor = 3;
                                      finalMap.clear();
                                      finalMap["likes"] =
                                          subjectFilter(3, "likes");
                                      finalMap["loves"] =
                                          subjectFilter(3, "loves");
                                      finalMap["hards"] =
                                          subjectFilter(3, "hards");
                                      Navigator.of(context).pop();

                                      setState(() {});
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: yearFilterColor == 2
                                          ? Colors.blue[50]
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.looks_two_rounded,
                                          color: yearFilterColor == 2
                                              ? Colors.blue
                                              : Colors.black45,
                                        ),
                                        Container(
                                          height: 40,
                                          child: AutoSizeText(
                                            "السنة الثانية فقط",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: yearFilterColor == 2
                                                  ? Colors.blue
                                                  : Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      yearFilterColor = 2;
                                      finalMap.clear();
                                      finalMap["likes"] =
                                          subjectFilter(2, "likes");
                                      finalMap["loves"] =
                                          subjectFilter(2, "loves");
                                      finalMap["hards"] =
                                          subjectFilter(2, "hards");
                                      Navigator.of(context).pop();

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Container(
                        height: 80,
                        child: Row(
                          children: [
                            Container(
                              width: 110,
                              decoration: BoxDecoration(
                                  color: yearFilterColor == 5
                                      ? Colors.blue[50]
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.looks_5_rounded,
                                      color: yearFilterColor == 5
                                          ? Colors.blue
                                          : Colors.black45,
                                    ),
                                    Container(
                                      height: 40,
                                      child: AutoSizeText(
                                        "السنة الخامسة فقط",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: yearFilterColor == 5
                                              ? Colors.blue
                                              : Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  yearFilterColor = 5;
                                  finalMap.clear();
                                  finalMap["likes"] = subjectFilter(5, "likes");
                                  finalMap["loves"] = subjectFilter(5, "loves");
                                  finalMap["hards"] = subjectFilter(5, "hards");
                                  Navigator.of(context).pop();

                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 110,
                              decoration: BoxDecoration(
                                  color: yearFilterColor == 4
                                      ? Colors.blue[50]
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.looks_4_rounded,
                                      color: yearFilterColor == 4
                                          ? Colors.blue
                                          : Colors.black45,
                                    ),
                                    Container(
                                      height: 40,
                                      child: AutoSizeText(
                                        "السنة الرابعة فقط",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: yearFilterColor == 4
                                              ? Colors.blue
                                              : Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  yearFilterColor = 4;
                                  finalMap.clear();
                                  finalMap["likes"] = subjectFilter(4, "likes");
                                  finalMap["loves"] = subjectFilter(4, "loves");
                                  finalMap["hards"] = subjectFilter(4, "hards");
                                  Navigator.of(context).pop();

                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            drawer: Mydrawer(),
            body: Consumer<ConnectivityProvider>(
                builder: (context, online, child) {
              List checkYearList = [];
              if (finalMap["likes"] != null) {
                checkYearList = finalMap["likes"];
              }
              if (online.isOnline == false) {
                return RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: subjects,
                    child: Offline());
              }
              if (online.isOnline == true) {
                return finalMap.isEmpty
                    ? RefreshWidget(
                        keyRefresh: keyRefresh,
                        onRefresh: subjects,
                        child: gridViewSkeleton())
                    : checkYearList.isNotEmpty
                        ? RefreshWidget(
                            keyRefresh: keyRefresh,
                            onRefresh: subjects,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: filter == "likes"
                                      ? Colors.red[100]
                                      : filter == "loves"
                                          ? Colors.blue[100]
                                          : Colors.green[100],
                                  height: 50,
                                  child: AutoSizeText(
                                      filter == "likes"
                                          ? "مصنف على حسب عدد الأعجابات"
                                          : filter == "loves"
                                              ? "مصنف على حسب نسبة حب المادة"
                                              : "مصنف على حسب نسبة صعوبة المادة ",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: filter == "likes"
                                              ? Colors.red
                                              : filter == "loves"
                                                  ? Colors.blue
                                                  : Colors.green,
                                          fontSize: 25)),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Color(0xffdadee7),
                                    child: GridView.builder(
                                      itemCount: finalMap["likes"].length ?? 0,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisExtent:
                                                  width < 330 ? 300 : 320,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 0),
                                      itemBuilder: (context, i) {
                                        if (delaytime < 700) {
                                          delaytime += 100;
                                        }
                                        return DelayedWidget(
                                          delayDuration:
                                              Duration(milliseconds: delaytime),
                                          animationDuration:
                                              Duration(milliseconds: 300),
                                          animation: DelayedAnimations
                                              .SLIDE_FROM_BOTTOM,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(AnimateSlider(
                                                          Page: Subjects(
                                                            subject: finalMap[
                                                                    '$filter'][i]
                                                                ["subjectName"],
                                                            arabSubject: finalMap[
                                                                    '$filter'][i]
                                                                ["arabicName"],
                                                            year: finalMap[
                                                                    '$filter']
                                                                [i]["year"],
                                                            sumester: finalMap[
                                                                    '$filter']
                                                                [i]["sumester"],
                                                            isauto: finalMap[
                                                                    '$filter']
                                                                [i]["isauto"],
                                                            iswork: finalMap[
                                                                    '$filter']
                                                                [i]["iswork"],
                                                            explain: finalMap[
                                                                    '$filter'][i]
                                                                [
                                                                "subjectExplain"],
                                                          ),
                                                          start: -1.0,
                                                          finish: 0.0))
                                                      .then((value) {
                                                    subjects();
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xffc8c8c8),
                                                            spreadRadius: 2,
                                                            offset:
                                                                Offset(5, 10),
                                                            blurRadius: 5)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    children: [
                                                      (i >= 0 && i < 3)
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: setTopColors(
                                                                                i),
                                                                            spreadRadius:
                                                                                2,
                                                                            offset:
                                                                                Offset.zero,
                                                                            blurRadius: 10)
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50.0)),
                                                              child: Icon(
                                                                Icons.star,
                                                                size: 30,
                                                                color:
                                                                    setTopColors(
                                                                        i),
                                                              ),
                                                            )
                                                          : Text(''),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      AutoSizeText(
                                                          "${i + 1} - ${finalMap['$filter'][i]['arabicName']} ",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          style: TextStyle(
                                                              color:
                                                                  setTopColors(
                                                                      i),
                                                              fontSize: 20)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.favorite,
                                                              color:
                                                                  Colors.red),
                                                          SizedBox(
                                                            width: 0,
                                                          ),
                                                          AutoSizeText(
                                                              "عدد الأعجابات :  ${finalMap['$filter'][i]['likes']}",
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          CircularPercentIndicator(
                                                            radius: width < 330
                                                                ? 50
                                                                : 60,
                                                            lineWidth:
                                                                width < 330
                                                                    ? 7
                                                                    : 10,
                                                            animation: true,
                                                            animationDuration:
                                                                3000,
                                                            curve: Curves
                                                                .easeInOut,
                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            percent: finalMap[
                                                                        "$filter"]
                                                                    [
                                                                    i]["loves"] /
                                                                100,
                                                            progressColor:
                                                                Colors.blue,
                                                            center: AutoSizeText(
                                                                "${double.parse((finalMap["$filter"][i]["loves"]).toStringAsFixed(1))}%",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300)),
                                                            footer: Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 8),
                                                              child: AutoSizeText(
                                                                  "نسبة حب المادة  ",
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                          CircularPercentIndicator(
                                                            radius: width < 330
                                                                ? 50
                                                                : 60,
                                                            lineWidth:
                                                                width < 330
                                                                    ? 7
                                                                    : 10,
                                                            animation: true,
                                                            animationDuration:
                                                                3000,
                                                            curve: Curves
                                                                .easeInOut,
                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            percent: finalMap[
                                                                        "$filter"]
                                                                    [
                                                                    i]["hards"] /
                                                                100,
                                                            progressColor:
                                                                Colors.green,
                                                            center: AutoSizeText(
                                                                "${double.parse((finalMap["$filter"][i]["hards"]).toStringAsFixed(1))}%",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300)),
                                                            footer: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: AutoSizeText(
                                                                  "نسبة صعوبة المادة  ",
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        : Container(
                            margin: EdgeInsets.only(top: size.height / 12),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.smile,
                                    color: Colors.grey,
                                    size: 100,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "لا يوجد مواد \n"
                                    "!! ${checkYearEmpty(yearFilterColor)} "
                                    " بعد",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 35, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ));
              }
              return gridViewSkeleton();
            })));
  }

  checkYearEmpty(year) {
    switch (year) {
      case 1:
        return "للسنة الأولى";
      case 2:
        return "للسنة الثانية";
      case 3:
        return "للسنة الثالثة";
      case 4:
        return "للسنة الرابعة";
      case 5:
        return "للسنة الخامسة";
    }
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
          bodyWidget: Text(""),
          titleWidget:
              Image.asset("images/Ratedsubject1.png", height: height * .4),
          footer: Container(
            height: height * .4,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText("هنا تجد تقييمات جميع المواد",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText("مقيمة على حسب جميع الطلاب",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(
                      "\n"
                      "مع أفضل ثلاث مواد مقيمة",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                )
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Ratedsubject2.png",
            height: height * .4,
            fit: BoxFit.fill,
          ),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(
                    " :  أفرز المواد على حسب "
                    "\n",
                    maxLines: 1,
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
                  child: AutoSizeText("  عدد الأعجابات _",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 800),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" نسبة حب المادة  _",
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 900),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" نسبة صعوبة المادة  _",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Ratedsubject3.png",
            height: height * .4,
            fit: BoxFit.fill,
          ),
          bodyWidget: Text(""),
          footer: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(
                    "فلتر المواد لترى تصنيف المواد الخاصة بسنة محددة",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
            ],
          ),
        ),
      ],
      onDone: () async {
        Navigator.of(context).pop();
      },
      done: Text("فهمت",
          style: TextStyle(
            fontSize: 15,
          )),
      dotsDecorator: DotsDecorator(size: Size.square(6)),
      showNextButton: true,
      next: Text("التالي",
          style: TextStyle(
            fontSize: 15,
          )),
      animationDuration: 700,
      curve: Curves.easeOut,
    );
  }
}
