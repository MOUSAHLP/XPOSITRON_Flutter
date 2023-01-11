import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_positron/mainpages/contactus.dart';
import 'package:x_positron/mainpages/questions.dart';
import 'package:x_positron/mainpages/subjects_rate.dart';
import 'package:x_positron/mainpages/user_subjects.dart';
import 'package:x_positron/mainpages/years.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/chooseAvatar.dart';
import 'package:x_positron/provider/subjects_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adverts.dart';
import 'auth.dart';
import 'home_page.dart';
import '../animation/slider.dart';
import 'package:http/http.dart' as http;

var f;

class Mydrawer extends StatefulWidget {
  const Mydrawer({Key? key}) : super(key: key);

  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  int change(int c) => f = c;
  navigate(var to) {
    Navigator.of(context)
        .pushReplacement(AnimateSlider(Page: to, start: -1.0, finish: 0.0));
  }

  static String? imagePath;
  static bool isImagePath = false;

  Future getUserImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/getUserImage.php");

      var response = await http.post(url, body: {
        "id": id,
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      imagePath = responsebody["userImage"];
      isImagePath = true;
      prefs.setString("image", responsebody["userImage"]);
    } catch (e) {
      print(e);
    }

    // setState(() {});
  }

  Color Yearscolor = Colors.grey;

  var username;
  var date;
  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    date = prefs.getString("date");
    if (prefs.containsKey("image")) {
      imagePath = prefs.getString("image");
    }
    setState(() {});
  }

  logout() async {
    var lastList =
        Provider.of<SubjectsInfo>(context, listen: false).vistedSubjects;
    lastList = [
      {"name": "", "year": ""},
      {"name": "", "year": ""},
      {"name": "", "year": ""},
      {"name": "", "year": ""},
      {"name": "", "year": ""}
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("id");
    await prefs.remove("username");
    await prefs.remove("password");
    await prefs.remove("year");
    await prefs.remove("date");

    navigate(Auth());
  }

  @override
  void initState() {
    shared();
    if (!isImagePath) {
      getUserImage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    double sectionNameFont = width < 330 ? 15 : 18;
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Colors.blue.shade700,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    InkWell(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: cachedImage(imagePath))
                            : Stack(
                                children: [
                                  Positioned(
                                    left: 20,
                                    top: 13,
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo, size: 50),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return ChosseAvatar();
                                            }).then((value) {
                                          print(value);
                                          if (value != null) imagePath = value;
                                          setState(() {});
                                        });
                                        ;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc) {
                              return ChosseAvatar();
                            }).then((value) {
                          print(value);
                          if (value != null) imagePath = value;
                          setState(() {});
                        });
                      },
                    ),
                    imagePath != null
                        ? Positioned(
                            bottom: -5,
                            left: -5,
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return ChosseAvatar();
                                      }).then((value) {
                                    print(value);
                                    if (value != null) imagePath = value;
                                    setState(() {});
                                  });
                                },
                                icon: Icon(Icons.add_a_photo_rounded,
                                    size: 35, color: Colors.grey)))
                        : Text(""),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      " $username",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          ":تم تسجيل الدخول في\n "
                          "$date",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                            onPressed: () {
                              showdialog(context, "التنقل السريع", intro());
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.questionCircle,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 0 || f == null ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("الصفحة الرئيسة",
                    style: TextStyle(
                        fontSize: sectionNameFont,
                        color:
                            f == 0 || f == null ? Colors.blue : Colors.grey)),
                leading: Icon(
                  Icons.home,
                  color: f == 0 ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    f = 0;
                  });
                  navigate(MyApp());
                },
              ),
            ),
          ),
          ExpansionTile(
            title: AutoSizeText("السنوات",
                style: TextStyle(
                    color: (f > 0 && f < 6) ? Colors.blue : Colors.grey,
                    fontSize: sectionNameFont)),
            collapsedBackgroundColor:
                (f > 0 && f < 6) ? Colors.blue[100] : Colors.white,
            leading: Icon(Icons.menu_book_rounded,
                color: (f > 0 && f < 6) ? Colors.blue : Colors.grey),
            onExpansionChanged: (iscollapsed) {
              if (iscollapsed == true) {
                setState(() {
                  Yearscolor = Colors.blue;
                });
              } else if (iscollapsed == false) {
                setState(() {
                  Yearscolor = Colors.grey;
                });
              }
            },
            childrenPadding: EdgeInsets.only(left: 30),
            children: [
              Card(
                margin: EdgeInsets.only(top: 20),
                color: f == 1 ? Colors.blue[100] : Colors.white,
                child: ListTile(
                  title: AutoSizeText("السنة الأولى",
                      style: TextStyle(
                          color: f == 1 ? Colors.blue : Colors.grey,
                          fontSize: sectionNameFont)),
                  leading: Icon(
                    Icons.looks_one_rounded,
                    color: f == 1 ? Colors.blue : Colors.grey,
                  ),
                  onTap: () {
                    f = 1;

                    setState(() {});
                    navigate(Years(
                      year: 1,
                    ));
                  },
                ),
              ),
              Card(
                color: f == 2 ? Colors.blue[100] : Colors.white,
                child: ListTile(
                  title: AutoSizeText("السنة الثانية",
                      style: TextStyle(
                          color: f == 2 ? Colors.blue : Colors.grey,
                          fontSize: sectionNameFont)),
                  leading: Icon(
                    Icons.looks_two_rounded,
                    color: f == 2 ? Colors.blue : Colors.grey,
                  ),
                  onTap: () {
                    f = 2;
                    setState(() {});
                    navigate(Years(
                      year: 2,
                    ));
                  },
                ),
              ),
              Card(
                color: f == 3 ? Colors.blue[100] : Colors.white,
                child: ListTile(
                  title: AutoSizeText("السنة الثالثة",
                      style: TextStyle(
                          color: f == 3 ? Colors.blue : Colors.grey,
                          fontSize: sectionNameFont)),
                  leading: Icon(
                    Icons.looks_3_rounded,
                    color: f == 3 ? Colors.blue : Colors.grey,
                  ),
                  onTap: () {
                    f = 3;
                    setState(() {});
                    navigate(Years(
                      year: 3,
                    ));
                  },
                ),
              ),
              Card(
                color: f == 4 ? Colors.blue[100] : Colors.white,
                child: ListTile(
                  title: AutoSizeText("السنة الرابعة",
                      style: TextStyle(
                          color: f == 4 ? Colors.blue : Colors.grey,
                          fontSize: sectionNameFont)),
                  leading: Icon(
                    Icons.looks_4_rounded,
                    color: f == 4 ? Colors.blue : Colors.grey,
                  ),
                  onTap: () {
                    f = 4;
                    setState(() {});
                    navigate(Years(
                      year: 4,
                    ));
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(bottom: 30),
                color: f == 5 ? Colors.blue[100] : Colors.white,
                child: ListTile(
                  title: AutoSizeText("السنة الخامسة",
                      style: TextStyle(
                          color: f == 5 ? Colors.blue : Colors.grey,
                          fontSize: sectionNameFont)),
                  leading: Icon(
                    Icons.looks_5_rounded,
                    color: f == 5 ? Colors.blue : Colors.grey,
                  ),
                  onTap: () {
                    f = 5;
                    setState(() {});
                    navigate(Years(
                      year: 5,
                    ));
                  },
                ),
              ),
            ],
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 6 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("المواد الأكثر تقييما",
                    style: TextStyle(
                        color: f == 6 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: FaIcon(
                  FontAwesomeIcons.chartLine,
                  color: f == 6 ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  f = 6;
                  setState(() {});
                  navigate(SubjectsRate());
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 7 ? Colors.red[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("تقييماتي",
                    style: TextStyle(
                        color: f == 7 ? Colors.red : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Icon(
                  Icons.favorite,
                  color: f == 7 ? Colors.red : Colors.grey,
                ),
                onTap: () {
                  f = 7;
                  setState(() {});
                  navigate(User_subjects());
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 8 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("الأسئلة الشائعة",
                    style: TextStyle(
                        color: f == 8 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Icon(
                  Icons.question_answer_rounded,
                  color: f == 8 ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  f = 8;
                  setState(() {});
                  navigate(Questions());
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 9 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("تواصل معنا",
                    style: TextStyle(
                        color: f == 9 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Icon(
                  Icons.feedback_rounded,
                  color: f == 9 ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  f = 9;
                  setState(() {});
                  navigate(ContactUs());
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 10 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("الاعلانات",
                    style: TextStyle(
                        color: f == 10 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Icon(
                  Icons.ad_units_rounded,
                  color: f == 10 ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  f = 10;
                  setState(() {});
                  navigate(Adverts());
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 11 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("موقعنا",
                    style: TextStyle(
                        color: f == 11 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Image.asset(
                  "images/positron2.png",
                  height: 28,
                  color: f == 11 ? Colors.blue : Colors.grey,
                ),
                onTap: () async {
                  f = 11;
                  setState(() {});
                  final url = "https://xpositron.000webhostapp.com";
                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false,
                      forceWebView: false,
                      enableJavaScript: true,
                      enableDomStorage: true,
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            height: width < 330
                ? 55
                : width > 400
                    ? 70
                    : 60,
            child: Card(
              color: f == 13 ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: AutoSizeText("تسجيل خروج",
                    style: TextStyle(
                        color: f == 13 ? Colors.blue : Colors.grey,
                        fontSize: sectionNameFont)),
                leading: Icon(
                  Icons.logout_rounded,
                  color: f == 13 ? Colors.blue : Colors.grey,
                ),
                onTap: () async {
                  f = 13;
                  await logout();
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  intro() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double responsiveFont = 15;
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Image.asset("images/Drawer1.png",
              fit: BoxFit.fitHeight, height: height * 0.3),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(" : للتنقل بين  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 600),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" الصفحة الرئيسية _ ",
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
                  child: AutoSizeText(" قائمة السنوات  _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText("قائمة المواد الأكثر تقييما _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 1100),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText("قائمة تقييماتي _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset("images/Drawer2.png", height: height * 0.3),
          bodyWidget: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(": أفتح القائمة المنسدلة ",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 700),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText("للتنقل بين السنين",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset("images/Drawer3.png", height: height * 0.3),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: AutoSizeText(" : للتنقل بين  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 800),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" قائمة الأسئلة الشائعة  _ ",
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
                  child: AutoSizeText("قسم تواصل معنا _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 950),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText("قسم الاعلانات _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" للانتقال الى موقعنا على الويب_ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 1100),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText("لتسجيل الخروج من الحساب _ ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset("images/Drawer4.png", height: height * 0.3),
          bodyWidget: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(" أختر الصورة التي تناسبك ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ),
            ],
          ),
        ),
      ],
      onDone: () async {
        Navigator.of(context).pop();
      },
      done: AutoSizeText("فهمت",
          style: TextStyle(
            fontSize: responsiveFont,
          )),
      dotsDecorator: DotsDecorator(size: Size.square(6)),
      dotsFlex: 2,
      showNextButton: true,
      next: AutoSizeText("التالي",
          style: TextStyle(
            fontSize: responsiveFont,
          )),
      animationDuration: 700,
      curve: Curves.easeOut,
    );
  }

  cachedImage(img) {
    return CachedNetworkImage(
      imageUrl: img,
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
    );
  }
}

class Change {
  Change(int c) {
    f = c;
  }
}
