import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:x_positron/provider/banner_ad.dart';
import 'package:x_positron/provider/connectivity.dart';
import 'package:x_positron/mainpages/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/offline.dart';
import 'package:x_positron/provider/refresh.dart';
import 'package:x_positron/provider/skeleton.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List questionsbody = [];
  List containertap = List.filled(100, false);
  List<double> angle = List.filled(100, 0.0);
  bool delayques = true;

  int delaytime = 200;

  final scrollController = ScrollController();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  late AnimationController controller1;
  late Animation animation1;
  late AnimationController controller2;
  late Animation animation2;

  Future questions() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/question_flutter.php");

      var response = await http.post(url, body: {
        "questions": "send",
      });
      var responsebody = jsonDecode(response.body);
      questionsbody.clear();
      questionsbody.addAll(responsebody);
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
              Navigator.of(context).pushReplacementNamed("questions");
            }).show();
      } catch (e) {}
    }

    setState(() {});
  }

  void onListen() {
    setState(() {});
  }

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      questions();
    }
    scrollController.addListener(onListen);

    Change(8);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(onListen);
  }

  DateTime preBackpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(preBackpress);
        final cantExit = timegap >= Duration(seconds: 2);
        preBackpress = DateTime.now();
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
              title: AutoSizeText(
                "الأسئلة الشائعة",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          showdialog(context, "الأسئلة الشائعة", intro());
                        },
                        icon: FaIcon(FontAwesomeIcons.questionCircle)))
              ]),
          drawer: Mydrawer(),
          body: Consumer<ConnectivityProvider>(
            builder: (context, online, child) {
              if (online.isOnline == false) {
                return RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: questions,
                    child: Offline());
              }
              if (online.isOnline == true) {
                return questionsbody.isEmpty
                    ? RefreshWidget(
                        keyRefresh: keyRefresh,
                        onRefresh: questions,
                        child: listViewSkeleton())
                    : RefreshWidget(
                        keyRefresh: keyRefresh,
                        onRefresh: questions,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: questionsbody.length,
                          itemBuilder: (context, i) {
                            final itemPositionOffset = i * 124;
                            final difference =
                                scrollController.offset - itemPositionOffset;
                            final percent = 1.0 - (difference / (124));
                            double opacity = percent;
                            double scale = percent;
                            if (opacity > 1.0) opacity = 1.0;
                            if (opacity < 0.0) opacity = 0.0;
                            if (percent > 1.0) scale = 1.0;

                            if (delaytime < 700) {
                              delaytime += 100;
                            }
                            if (i == 7) {
                              delayques = false;
                            }
                            if (containertap.contains(true)) {
                              opacity = 1.0;
                              scale = 1.0;
                            }
                            return Opacity(
                              opacity: opacity,
                              child: Transform.scale(
                                scale: scale,
                                child: DelayedWidget(
                                  enabled: delayques,
                                  delayDuration:
                                      Duration(milliseconds: delaytime),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 30),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: size.height / 10,
                                          decoration: BoxDecoration(
                                            color: Color(0xff10cab7),
                                            borderRadius: containertap[i] ==
                                                    false
                                                ? BorderRadius.circular(20)
                                                : BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    "${questionsbody[i]['question']}",
                                                    maxLines: 1,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Text(
                                                  " - ${i + 1}",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            trailing: Transform.rotate(
                                              angle: angle[i],
                                              child: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.black,
                                                size: 50,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                containertap[i] =
                                                    !containertap[i];
                                              });
                                              if (containertap[i] == true) {
                                                controller1 =
                                                    AnimationController(
                                                  vsync: this,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                );

                                                animation1 = Tween(
                                                  begin: 0.0,
                                                  end: 3.14 / 2,
                                                ).animate(controller1)
                                                  ..addListener(() {
                                                    setState(() {
                                                      angle[i] =
                                                          animation1.value;
                                                    });
                                                  });
                                                controller1.forward();
                                              } else if (containertap[i] ==
                                                  false) {
                                                controller2 =
                                                    AnimationController(
                                                  vsync: this,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                );

                                                animation2 = Tween(
                                                  begin: 3.14 / 2,
                                                  end: 0.0,
                                                ).animate(controller2)
                                                  ..addListener(() {
                                                    setState(() {
                                                      angle[i] =
                                                          animation2.value;
                                                    });
                                                  });
                                                controller2.forward();
                                              }
                                            },
                                          ),
                                        ),
                                        AnimatedCrossFade(
                                            firstChild: Container(
                                              height: 0,
                                              color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(""),
                                            ),
                                            secondChild: InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20))),
                                                child: Text(
                                                    "${questionsbody[i]['answer']}",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  containertap[i] =
                                                      !containertap[i];
                                                });
                                                if (containertap[i] == true) {
                                                  controller1 =
                                                      AnimationController(
                                                    vsync: this,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                  );

                                                  animation1 = Tween(
                                                    begin: 0.0,
                                                    end: 3.14 / 2,
                                                  ).animate(controller1)
                                                    ..addListener(() {
                                                      setState(() {
                                                        angle[i] =
                                                            animation1.value;
                                                      });
                                                    });
                                                  controller1.forward();
                                                } else if (containertap[i] ==
                                                    false) {
                                                  controller2 =
                                                      AnimationController(
                                                    vsync: this,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                  );

                                                  animation2 = Tween(
                                                    begin: 3.14 / 2,
                                                    end: 0.0,
                                                  ).animate(controller2)
                                                    ..addListener(() {
                                                      setState(() {
                                                        angle[i] =
                                                            animation2.value;
                                                      });
                                                    });
                                                  controller2.forward();
                                                }
                                              },
                                            ),
                                            crossFadeState:
                                                containertap[i] == false
                                                    ? CrossFadeState.showFirst
                                                    : CrossFadeState.showSecond,
                                            duration:
                                                Duration(milliseconds: 700)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              }

              return listViewSkeleton();
            },
          )),
    );
  }

  intro() {
    double width = MediaQuery.of(context).size.width;
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Image.asset(
            "images/Questions1.png",
          ),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text("هنا تجد أسئلة عن القسم و الجامعة مجاب عنها",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Color(0xff909295))),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Questions2.png",
          ),
          bodyWidget: Text(""),
          footer: DelayedWidget(
            delayDuration: Duration(milliseconds: 400),
            animationDuration: Duration(milliseconds: 700),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            child: Text(" أضغط على السؤال لترى الأجابة",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xff909295))),
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
