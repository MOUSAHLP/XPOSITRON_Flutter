import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:x_positron/provider/subjects_info.dart';

class User_subjects extends StatefulWidget {
  const User_subjects({Key? key}) : super(key: key);

  @override
  _User_subjectsState createState() => _User_subjectsState();
}

class _User_subjectsState extends State<User_subjects>
    with WidgetsBindingObserver {
  static Map<String, dynamic> posts = Map();
  List<Map> subjectList = [];
  static Map<String, dynamic> finalMap = {};

  int delaytime = 200;
  var id;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  String filter = "is_love";
  Future subjects() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/user_subjects.php");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = await prefs.getString("id");
      var response = await http.post(url, body: {
        "id": id,
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
            Navigator.of(context).pushReplacementNamed("userSubjects");
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

  subjectListFun(year) {
    var subjectAdd;
    var _subjectList = Provider.of<SubjectsInfo>(context, listen: false);
    switch (year) {
      case 1:
        subjectAdd = _subjectList.firstYear;
        break;
      case 2:
        subjectAdd = _subjectList.secondyear;
        break;
      case 3:
        subjectAdd = _subjectList.thirdyear;
        break;
      case 4:
        subjectAdd = _subjectList.forthyear;
        break;
      case 5:
        subjectAdd = _subjectList.fifthyear;
        break;
    }
    subjectAdd.forEach((element) {
      Map _map = Map();
      _map["subjectName"] = element["subjectName"];
      _map["arabicName"] = element["arabicName"];
      _map["year"] = element["year"];
      _map["sumester"] = element["sumester"];
      _map["isauto"] = element["isauto"];
      _map["iswork"] = element["iswork"];
      _map["subjectExplain"] = element["subjectExplain"];
      _map["image"] = element["image"];
      subjectList.add(_map);
    });
  }

  subjectListFunAdd() {
    subjectListFun(1);
    subjectListFun(2);
    subjectListFun(3);
    subjectListFun(4);
    subjectListFun(5);
  }

  votedFilter(year) {
    switch (year) {
      case 0:
        finalMap.addAll(posts);
        break;
      default:
        finalMap["is_like"] = subjectFilter(year, "is_like");
        finalMap["is_love"] = subjectFilter(year, "is_love");
        finalMap["is_hard"] = subjectFilter(year, "is_hard");
        break;
    }
  }

  int yearFilterColor = 0;
  subjectFilter(year, filterfun) {
    List _list = posts["$filterfun"];
    List _finalList = [];
    var currentYearSubjects;
    for (int i = 0; i < subjectList.length; i++) {
      currentYearSubjects =
          subjectList.where((element) => element['year'] == "$year");
    }

    _list.forEach((element) {
      currentYearSubjects.forEach((taskele) {
        if (element["subject"] == taskele["subjectName"]) {
          _finalList.add(element);
        }
      });
    });

    return _finalList;
  }

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      subjects();
    }

    subjectListFunAdd();
    Change(7);
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
              title: AutoSizeText(
                "تقييماتي",
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              bottomOpacity: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      showdialog(context, "تقييماتي", intro());
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
                                  color: filter == "is_hard"
                                      ? Colors.green[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "نسبة\n صعوبة المادة",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "is_hard"
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "is_hard";

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: filter == "is_like"
                                      ? Colors.red[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "عدد\n الأعجابات",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "is_like"
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "is_like";

                              Navigator.of(context).pop();

                              setState(() {});
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: filter == "is_love"
                                      ? Colors.blue[50]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "نسبة\n حب المادة",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: filter == "is_love"
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              filter = "is_love";

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
                                finalMap["is_like"] =
                                    subjectFilter(1, "is_like");
                                finalMap["is_love"] =
                                    subjectFilter(1, "is_love");
                                finalMap["is_hard"] =
                                    subjectFilter(1, "is_hard");
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
                                      finalMap["is_like"] =
                                          subjectFilter(3, "is_like");
                                      finalMap["is_love"] =
                                          subjectFilter(3, "is_love");
                                      finalMap["is_hard"] =
                                          subjectFilter(3, "is_hard");
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
                                      finalMap["is_like"] =
                                          subjectFilter(2, "is_like");
                                      finalMap["is_love"] =
                                          subjectFilter(2, "is_love");
                                      finalMap["is_hard"] =
                                          subjectFilter(2, "is_hard");
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
                                  finalMap["is_like"] =
                                      subjectFilter(5, "is_like");
                                  finalMap["is_love"] =
                                      subjectFilter(5, "is_love");
                                  finalMap["is_hard"] =
                                      subjectFilter(5, "is_hard");
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
                                  finalMap["is_like"] =
                                      subjectFilter(4, "is_like");
                                  finalMap["is_love"] =
                                      subjectFilter(4, "is_love");
                                  finalMap["is_hard"] =
                                      subjectFilter(4, "is_hard");
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
                        child: gridViewSkeleton(),
                      )
                    : finalMap["is_like"].length > 0 ||
                            finalMap["is_love"].length > 0 ||
                            finalMap["is_hard"].length > 0
                        ? RefreshWidget(
                            keyRefresh: keyRefresh,
                            onRefresh: subjects,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: filter == "is_like"
                                      ? Colors.red[100]
                                      : filter == "is_love"
                                          ? Colors.blue[100]
                                          : Colors.green[100],
                                  height: 50,
                                  child: AutoSizeText(
                                      filter == "is_like"
                                          ? "مصنف على حسب عدد الأعجابات"
                                          : filter == "is_love"
                                              ? "مصنف على حسب نسبة حب المادة"
                                              : "مصنف على حسب نسبة صعوبة المادة ",
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: filter == "is_like"
                                              ? Colors.red
                                              : filter == "is_love"
                                                  ? Colors.blue
                                                  : Colors.green,
                                          fontSize: 25)),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Color(0xffdadee7),
                                    child: GridView.builder(
                                      itemCount:
                                          finalMap["is_like"].length ?? 0,
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
                                                  var task = subjectList.where(
                                                      (element) =>
                                                          element[
                                                              'subjectName'] ==
                                                          finalMap['$filter'][i]
                                                              ['subject']);
                                                  task.forEach((element) {
                                                    Navigator.of(context)
                                                        .push(AnimateSlider(
                                                            Page: Subjects(
                                                              subject: element[
                                                                  "subjectName"],
                                                              arabSubject: element[
                                                                  "arabicName"],
                                                              year: element[
                                                                  "year"],
                                                              sumester: element[
                                                                  "sumester"],
                                                              isauto: element[
                                                                  "isauto"],
                                                              iswork: element[
                                                                  "iswork"],
                                                              explain: element[
                                                                  "subjectExplain"],
                                                            ),
                                                            start: -1.0,
                                                            finish: 0.0))
                                                        .then((value) {
                                                      subjects();
                                                      setState(() {});
                                                    });
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
                                                              10.0)),
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
                                                          "${i + 1} - ${finalMap['$filter'][i]['arab-name']} ",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                          Icon(
                                                            Icons.favorite,
                                                            color: finalMap["is_like"]
                                                                            [i][
                                                                        "is_like"] ==
                                                                    '1'
                                                                ? Colors.red
                                                                : Colors.grey,
                                                          ),
                                                          SizedBox(
                                                            width: 0,
                                                          ),
                                                          SizedBox(width: 10),
                                                          AutoSizeText(
                                                              finalMap["is_like"]
                                                                              [i][
                                                                          "is_like"] ==
                                                                      '1'
                                                                  ? "أعجبتك"
                                                                  : "لم تعجبك",
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: finalMap["is_like"][i]
                                                                              [
                                                                              "is_like"] ==
                                                                          '1'
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey,
                                                                  fontSize: 15))
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
                                                                        "$filter"][i]
                                                                    [
                                                                    "love_percentage"] /
                                                                10,
                                                            progressColor:
                                                                Colors.blue,
                                                            center: AutoSizeText(
                                                                "${double.parse(finalMap["$filter"][i]["love_percentage"].toString()).toStringAsFixed(0)}",
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
                                                                  "نسبة حبك للمادة  ",
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
                                                                        "$filter"][i]
                                                                    [
                                                                    "hard_percentage"] /
                                                                10,
                                                            progressColor:
                                                                Colors.green,
                                                            center: Text(
                                                                "${double.parse(finalMap["$filter"][i]["hard_percentage"].toString()).toStringAsFixed(0)}",
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
                                                                  "نسبة صعوبتك للمادة  ",
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
                        : RefreshWidget(
                            keyRefresh: keyRefresh,
                            onRefresh: subjects,
                            child: ListView(children: [
                              Container(
                                margin: EdgeInsets.only(top: size.height / 3.3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mood,
                                        size: 80, color: Color(0xffc8c8c8)),
                                    Text(
                                      "هنا تجد جميع المواد\n التي قمت بتقييمها",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xffc8c8c8)),
                                    ),
                                  ],
                                ),
                              )
                            ]));
              }
              return gridViewSkeleton();
            })));
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
          titleWidget: Image.asset(
            "images/Mysubject1.png",
            height: height * .4,
          ),
          footer: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(" هنا تجد المواد التي قمت بتقييمها",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 700),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(
                    "\n"
                    "مع أفضل ثلاث مواد قمت بتقييمها",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              )
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Mysubject2.png",
            height: height * .4,
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
                      maxLines: 1,
                      textAlign: TextAlign.right,
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
            "images/Mysubject3.png",
            height: height * .4,
          ),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(
                    "فلتر المواد لترى تصنيف المواد التي قمت بتقييمها الخاصة بسنة محددة",
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
