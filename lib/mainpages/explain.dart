import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/subjects.dart';
import 'package:x_positron/provider/subjects_info.dart';

class Explain extends StatefulWidget {
  final subject;
  final arabSubject;
  final year;
  final sumester;
  final explain;
  final isauto;
  final iswork;
  const Explain(
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
  _ExplainState createState() => _ExplainState();
}

class _ExplainState extends State<Explain> {
  List<Map> firstsum = [];
  List<Map> secondsum = [];

  explainfun() {
    var subjects = Provider.of<SubjectsInfo>(context, listen: false);

    var yearSubject;

    switch (widget.year) {
      case "1":
        yearSubject = subjects.firstYear;
        break;
      case "2":
        yearSubject = subjects.secondyear;

        break;
      case "3":
        yearSubject = subjects.thirdyear;

        break;
      case "4":
        yearSubject = subjects.forthyear;

        break;
      case "5":
        yearSubject = subjects.fifthyear;

        break;
    }
    if (widget.sumester == "1") {
      yearSubject.forEach((element) {
        if (element["subjectName"] != widget.subject &&
            element["sumester"] == "1") {
          firstsum.add(element);
        }
        if (element["sumester"] == "2") {
          secondsum.add(element);
        }
      });
    } else if (widget.sumester == "2") {
      yearSubject.forEach((element) {
        if (element["subjectName"] != widget.subject &&
            element["sumester"] == "2") {
          secondsum.add(element);
        }
        if (element["sumester"] == "1") {
          firstsum.add(element);
        }
      });
    }
  }

  whichYear(year) {
    switch (year) {
      case "1":
        return 'سنة أولى';
      case "2":
        return 'سنة ثانية';
      case "3":
        return 'سنة ثالثة';
      case "4":
        return 'سنة رابعة';
      case '5':
        return 'سنة خامسة';
    }
  }

  whichYearal(year) {
    switch (year) {
      case "1":
        return 'السنة الأولى';
      case "2":
        return 'السنة الثانية';
      case "3":
        return 'السنة الثالثة';
      case "4":
        return 'السنة الرابعة';
      case "5":
        return 'السنة الخامسة';
    }
  }

  @override
  void initState() {
    explainfun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: width * .7,
                  child: AutoSizeText("X-POSITRON",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[600],
                          fontFamily: 'serif')),
                ),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 15, right: 20, bottom: 10),
                    child: AutoSizeText("${widget.arabSubject}",
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white70,
                        ))),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 0, right: 20, bottom: 20),
                    child: AutoSizeText("${whichYear(widget.year)}",
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                        ))),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    widget.sumester == "1"
                        ? Icon(
                            Icons.looks_one_rounded,
                            size: 30,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.looks_two_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                    Text("فصل",
                        style: TextStyle(
                            fontSize: width < 330 ? 16 : 20,
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
                    widget.iswork == "1"
                        ? Icon(
                            Icons.check_circle_outline_rounded,
                            size: 30,
                            color: Colors.green[300],
                          )
                        : Icon(
                            Icons.block_rounded,
                            size: 30,
                            color: Colors.red[300],
                          ),
                    Text("عملي",
                        style: TextStyle(
                            fontSize: width < 330 ? 16 : 20,
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
                    widget.isauto == "1"
                        ? Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.green[300],
                          )
                        : Icon(
                            Icons.warning_rounded,
                            size: 30,
                            color: Colors.red[300],
                          ),
                    Text("أتمتة",
                        style: TextStyle(
                            fontSize: width < 330 ? 16 : 20,
                            color: Color(0xff909295))),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "${widget.explain}",
              style: TextStyle(
                  color: Color(0xff909295),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 4, 10, 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Text(
                  widget.sumester == "1"
                      ? "مواد فصل أول من ${whichYearal(widget.year)} اخرى"
                      : "مواد فصل ثاني من ${whichYearal(widget.year)} اخرى",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: width < 330 ? 16 : 18,
                      fontWeight: FontWeight.bold),
                )),
                Container(
                    width: double.infinity,
                    height: 210,
                    child: widget.sumester == "1"
                        ? subjectListView(firstsum)
                        : subjectListView(secondsum)),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Text(
                  widget.sumester == "1"
                      ? "مواد فصل ثاني من ${whichYearal(widget.year)}"
                      : "مواد فصل أول من ${whichYearal(widget.year)}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: width < 330 ? 16 : 18,
                      fontWeight: FontWeight.bold),
                )),
                Container(
                    width: double.infinity,
                    height: 210,
                    child: widget.sumester == "2"
                        ? subjectListView(firstsum)
                        : secondsum.isNotEmpty
                            ? subjectListView(secondsum)
                            : Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                        "لا يوجد مواد "
                                        "${whichYear(widget.year)}"
                                        " فصل تاني بعد ",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 30)),
                                    Icon(Icons.mood_bad_rounded, size: 60)
                                  ],
                                ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subjectListView(List<Map> map) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: map.length,
          itemBuilder: (context, i) {
            return Container(
              width: 140,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xffe6f8fc),
                  borderRadius: BorderRadius.circular(10.0)),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: map[i]["image"],
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
                      "${map[i]["arabicName"]}",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff5E6167),
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            map[i]["sumester"] == "1"
                                ? Icon(
                                    Icons.looks_one_rounded,
                                    color: Colors.blue,
                                    size: width < 330 ? 25 : 27,
                                  )
                                : Icon(
                                    Icons.looks_two_rounded,
                                    color: Colors.blue,
                                    size: width < 330 ? 25 : 27,
                                  ),
                            Text("فصل",
                                style: TextStyle(
                                    fontSize: width < 330 ? 16 : 18,
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
                            map[i]["iswork"] == "1"
                                ? Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.green[300],
                                    size: width < 330 ? 25 : 27,
                                  )
                                : Icon(
                                    Icons.block_rounded,
                                    color: Colors.red[300],
                                    size: width < 330 ? 25 : 27,
                                  ),
                            Text("عملي",
                                style: TextStyle(
                                    fontSize: width < 330 ? 16 : 18,
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
                            map[i]["isauto"] == "1"
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green[300],
                                    size: width < 330 ? 25 : 27,
                                  )
                                : Icon(
                                    Icons.warning_rounded,
                                    color: Colors.red[300],
                                    size: width < 330 ? 25 : 27,
                                  ),
                            Text("أتمتة",
                                style: TextStyle(
                                    fontSize: width < 330 ? 16 : 18,
                                    color: Color(0xff909295))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(AnimateSlider(
                      Page: Subjects(
                        subject: map[i]["subjectName"],
                        arabSubject: map[i]["arabicName"],
                        year: map[i]["year"],
                        sumester: map[i]["sumester"],
                        isauto: map[i]["isauto"],
                        iswork: map[i]["iswork"],
                        explain: map[i]["subjectExplain"],
                      ),
                      start: -1.0,
                      finish: 0.0));
                },
              ),
            );
          }),
    );
  }
}
