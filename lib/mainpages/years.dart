import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:provider/provider.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/drawer.dart';
import 'package:flutter/material.dart';
import 'package:x_positron/mainpages/subjects.dart';

import 'package:x_positron/provider/banner_ad.dart';
import 'package:x_positron/provider/subjects_info.dart';
import 'package:create_atom/create_atom.dart';

class Years extends StatefulWidget {
  final year;
  const Years({Key? key, this.year}) : super(key: key);
  @override
  _YearsState createState() => _YearsState();
}

class _YearsState extends State<Years> with WidgetsBindingObserver {
  List<Map> subjectList = [];
  static bool grid_list = false;
  int delaytime = 200;
  bool delayList = true;
  bool delaygrid = true;

  final scrollControllerlist = ScrollController();
  final scrollControllergrid = ScrollController();

  void onListen() {
    setState(() {});
  }

  change_grid_list(bool gl) {
    if (gl == true) {
      return IconButton(
          onPressed: () {
            grid_list = false;
            delaygrid = true;
            delayList = true;
            setState(() {});
          },
          icon: Icon(Icons.apps_rounded));
    } else {
      return IconButton(
          onPressed: () {
            grid_list = true;
            delaygrid = true;
            delayList = true;
            setState(() {});
          },
          icon: Icon(Icons.format_list_bulleted_rounded));
    }
  }

  appbartittle(year) {
    switch (year) {
      case 1:
        return "السنة الأولى";

      case 2:
        return "السنة الثانية";
      case 3:
        return "السنة الثالثة";
      case 4:
        return "السنة الرابعة";
      case 5:
        return "السنة الخامسة";
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

  @override
  void initState() {
    super.initState();
    if (subjectList.isEmpty) {
      subjectListFun(widget.year);
    }

    scrollControllerlist.addListener(onListen);
    scrollControllergrid.addListener(onListen);
  }

  @override
  void dispose() {
    scrollControllerlist.removeListener(onListen);
    scrollControllergrid.removeListener(onListen);

    super.dispose();
  }

  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
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
          bottomNavigationBar: AdBanner(),
          appBar: AppBar(
            title: Text(
              "${appbartittle(widget.year)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [change_grid_list(grid_list)],
          ),
          drawer: Mydrawer(),
          body: subjectList.isEmpty
              ? isEmptySubject(widget.year)
              : grid_list == false
                  ? subjectGridView()
                  : subjectListView()),
    );
  }

  Widget subjectListView() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double responsiveIcon = width < 330 ? 25 : 35;
    double responsiveIconText = width < 330 ? 16 : 20;
    return Container(
      color: Color(0xffdadee7),
      child: ListView.builder(
          controller: scrollControllerlist,
          itemCount: subjectList.length,
          itemBuilder: (context, i) {
            final itemPositionOffset = i * 160;
            final difference = scrollControllerlist.offset - itemPositionOffset;
            final percent = 1.0 - (difference / (160));
            double opacity = percent;
            double scale = percent;
            if (opacity > 1.0) opacity = 1.0;
            if (opacity < 0.0) opacity = 0.0;
            if (percent > 1.0) scale = 1.0;

            if (i == 0) {
              delaytime = 200;
            }
            if (delaytime < 700) {
              delaytime += 100;
            }
            if (i == 6) {
              delayList = false;
            }

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: (scale),
                child: DelayedWidget(
                  enabled: delayList,
                  delayDuration: Duration(milliseconds: delaytime),
                  animationDuration: Duration(milliseconds: 300),
                  animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffc8c8c8),
                              spreadRadius: 2,
                              offset: Offset(5, 10),
                              blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListTile(
                      title: Container(
                        width: double.infinity,
                        child: AutoSizeText(
                          "${subjectList[i]["arabicName"]}",
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(0xff5E6167),
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              subjectList[i]["sumester"] == "1"
                                  ? Icon(
                                      Icons.looks_one_rounded,
                                      color: Colors.blue,
                                      size: responsiveIcon,
                                    )
                                  : Icon(
                                      Icons.looks_two_rounded,
                                      color: Colors.blue,
                                      size: responsiveIcon,
                                    ),
                              Text("فصل",
                                  style: TextStyle(
                                      fontSize: responsiveIconText,
                                      color: Color(0xff909295))),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(""),
                              width: 1,
                              height: 50,
                              color: Color(0xff909295)),
                          Column(
                            children: [
                              subjectList[i]["iswork"] == "1"
                                  ? Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.green[300],
                                      size: responsiveIcon,
                                    )
                                  : Icon(
                                      Icons.block_rounded,
                                      color: Colors.red[300],
                                      size: responsiveIcon,
                                    ),
                              Text("عملي",
                                  style: TextStyle(
                                      fontSize: responsiveIconText,
                                      color: Color(0xff909295))),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(""),
                              width: 1,
                              height: 50,
                              color: Color(0xff909295)),
                          Column(
                            children: [
                              subjectList[i]["isauto"] == "1"
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green[300],
                                      size: responsiveIcon,
                                    )
                                  : Icon(
                                      Icons.warning_rounded,
                                      color: Colors.red[300],
                                      size: responsiveIcon,
                                    ),
                              Text("أتمتة",
                                  style: TextStyle(
                                      fontSize: responsiveIconText,
                                      color: Color(0xff909295))),
                            ],
                          ),
                        ],
                      ),
                      trailing: CachedNetworkImage(
                        imageUrl: subjectList[i]["image"],
                        height: 55,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.elasticOut,
                        placeholder: (context, url) => Atom(
                          size: 55,
                          nucleusRadiusFactor: 2,
                          orbitsColor: Colors.blue,
                          nucleusColor: Colors.blue,
                          electronsColor: Colors.blue,
                          orbit1Angle: (0),
                          orbit2Angle: (3.14 / 3),
                          orbit3Angle: (3.14 / -3),
                          animDuration1: Duration(milliseconds: 1000),
                          animDuration2: Duration(milliseconds: 1300),
                          animDuration3: Duration(milliseconds: 800),
                        ),
                        errorWidget: (context, url, error) => Atom(
                          size: 55,
                          nucleusRadiusFactor: 2,
                          orbitsColor: Colors.red,
                          nucleusColor: Colors.red,
                          electronsColor: Colors.red,
                          orbit1Angle: (0),
                          orbit2Angle: (3.14 / 3),
                          orbit3Angle: (3.14 / -3),
                          animDuration1: Duration(milliseconds: 1000),
                          animDuration2: Duration(milliseconds: 1300),
                          animDuration3: Duration(milliseconds: 800),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(AnimateSlider(
                            Page: Subjects(
                              subject: subjectList[i]["subjectName"],
                              arabSubject: subjectList[i]["arabicName"],
                              year: subjectList[i]["year"],
                              sumester: subjectList[i]["sumester"],
                              isauto: subjectList[i]["isauto"],
                              iswork: subjectList[i]["iswork"],
                              explain: subjectList[i]["subjectExplain"],
                            ),
                            start: -1.0,
                            finish: 0.0));
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget subjectGridView() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double responsiveIcon = width < 330 ? 25 : 35;
    double responsiveIconText = width < 330 ? 16 : 20;
    return Container(
      color: Color(0xffdadee7),
      child: GridView.builder(
          controller: scrollControllergrid,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 200,
              crossAxisCount: 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 5),
          itemCount: subjectList.length,
          itemBuilder: (context, i) {
            int index = i % 2 == 0 ? i : i - 1;
            final itemPositionOffset = index * 110;
            final difference = scrollControllergrid.offset - itemPositionOffset;
            final percent = 1.0 - (difference / (110));
            double opacity = percent;
            double scale = percent;
            if (opacity > 1.0) opacity = 1.0;
            if (opacity < 0.0) opacity = 0.0;
            if (percent > 1.0) scale = 1.0;

            if (i == 0) {
              delaytime = 200;
            }
            if (delaytime < 700) {
              delaytime += 100;
            }
            if (i == 8) {
              delaygrid = false;
            }
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: DelayedWidget(
                  enabled: delaygrid,
                  delayDuration: Duration(milliseconds: delaytime),
                  animationDuration: Duration(milliseconds: 300),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 500,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffc8c8c8),
                              spreadRadius: 2,
                              offset: Offset(5, 10),
                              blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CachedNetworkImage(
                            imageUrl: subjectList[i]["image"],
                            height: 60,
                            fit: BoxFit.cover,
                            fadeInCurve: Curves.elasticOut,
                            placeholder: (context, url) => Atom(
                              size: 60,
                              nucleusRadiusFactor: 2,
                              orbitsColor: Colors.blue,
                              nucleusColor: Colors.blue,
                              electronsColor: Colors.blue,
                              orbit1Angle: (0),
                              orbit2Angle: (3.14 / 3),
                              orbit3Angle: (3.14 / -3),
                              animDuration1: Duration(milliseconds: 1000),
                              animDuration2: Duration(milliseconds: 1300),
                              animDuration3: Duration(milliseconds: 800),
                            ),
                            errorWidget: (context, url, error) => Atom(
                              size: 60,
                              nucleusRadiusFactor: 2,
                              orbitsColor: Colors.red,
                              nucleusColor: Colors.red,
                              electronsColor: Colors.red,
                              orbit1Angle: (0),
                              orbit2Angle: (3.14 / 3),
                              orbit3Angle: (3.14 / -3),
                              animDuration1: Duration(milliseconds: 1000),
                              animDuration2: Duration(milliseconds: 1300),
                              animDuration3: Duration(milliseconds: 800),
                            ),
                          ),
                          AutoSizeText(
                            "${subjectList[i]["arabicName"]}",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff5E6167),
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  subjectList[i]["sumester"] == "1"
                                      ? Icon(
                                          Icons.looks_one_rounded,
                                          color: Colors.blue,
                                          size: 25,
                                        )
                                      : Icon(
                                          Icons.looks_two_rounded,
                                          color: Colors.blue,
                                          size: 25,
                                        ),
                                  Text("فصل",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff909295))),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(""),
                                  width: 1,
                                  height: 41,
                                  color: Color(0xff909295)),
                              Column(
                                children: [
                                  subjectList[i]["iswork"] == "1"
                                      ? Icon(
                                          Icons.check_circle_outline_outlined,
                                          color: Colors.green[300],
                                          size: 25,
                                        )
                                      : Icon(
                                          Icons.block_rounded,
                                          color: Colors.red[300],
                                          size: 25,
                                        ),
                                  Text("عملي",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff909295))),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(""),
                                  width: 1,
                                  height: 41,
                                  color: Color(0xff909295)),
                              Column(
                                children: [
                                  subjectList[i]["isauto"] == "1"
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.green[300],
                                          size: 25,
                                        )
                                      : Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red[300],
                                          size: 25,
                                        ),
                                  Text("أتمتة",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff909295))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(AnimateSlider(
                            Page: Subjects(
                              subject: subjectList[i]["subjectName"],
                              arabSubject: subjectList[i]["arabicName"],
                              year: subjectList[i]["year"],
                              sumester: subjectList[i]["sumester"],
                              isauto: subjectList[i]["isauto"],
                              iswork: subjectList[i]["iswork"],
                              explain: subjectList[i]["subjectExplain"],
                            ),
                            start: -1.0,
                            finish: 0.0));
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  isEmptySubjectContent(imageUrl) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
            width: width * .9,
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  height: height * .6,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    "images/$imageUrl",
                    fit: BoxFit.fill,
                  ),
                ),
                AutoSizeText(
                  " هنا تجد جميع مواد "
                  "\n"
                  "${appbartittle(widget.year)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width < 330 ? 22 : 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff909295)),
                ),
                SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  "علما أنك ستجدها عند صدورها"
                  "\n"
                  "بدون تحديث التطبيق",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width < 330 ? 18 : 22,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff909295)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  isEmptySubject(year) {
    switch (year) {
      case 2:
        return isEmptySubjectContent("share.png");
      case 3:
        return isEmptySubjectContent("Year3.png");
      case 4:
        return isEmptySubjectContent("Year4.png");
      case 5:
        return isEmptySubjectContent("Year5.png");
    }
  }
}
