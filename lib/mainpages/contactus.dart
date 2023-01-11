import 'package:auto_size_text/auto_size_text.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:x_positron/provider/connectivity.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/userdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawer.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> with WidgetsBindingObserver {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  List posts = [];

  Future contactus() async {
    final url = Uri.parse(
        "https://xpositron.000webhostapp.com/flutter/contactus_flutter.php");

    var response = await http.post(url, body: {
      "username": "$username",
      "email": "$email",
      "message": "$message"
    });
    var responsebody = await jsonDecode(response.body);
    if (responsebody['response'] == 'send done') {
      Navigator.of(context).pop();

      try {
        AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'تم أرسال الرسالة',
          desc: 'تم أرساال الرسالة التي ارسلتها بنجاح \n سيصلك رسالة تأكيد',
          btnOkText: "Ok",
          btnOkOnPress: () {
            Navigator.of(context).pushReplacementNamed("contactus");
          },
        ).show();
      } catch (e) {}
    } else {
      Navigator.of(context).pop();
    }
  }

  var username;

  var email;
  var input_email = "";
  var enabled_email;
  double _checkemail = -40.0;
  double _warningemail = 140.0;

  regexp_email(String iv) {
    if (iv.length != 0) {
      if (!RegExp(
              r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
          .hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  error_email(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabled_email == null && iv.length == 0) {
        enabled_email = Colors.blue;
      }
      if ((iv.length > 0 && iv.length < 4) || regexp_email(iv)) {
        _checkemail = -40.0;
        _warningemail = 20;
        enabled_email = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkemail = 5.0;
          _warningemail = 120.0;
          enabled_email = Colors.green[300];
        }
      }
    }
  }

  var message;
  var input_message = "";
  var enabled_message;
  double _checkmessage = -40.0;
  double _warningmessage = 240.0;

  error_message(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabled_message == null && iv.length == 0) {
        enabled_message = Colors.blue;
      }
      if ((iv.length > 0 && iv.length < 11)) {
        _checkmessage = -40.0;
        _warningmessage = 40;
        enabled_message = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkmessage = 5.0;
          _warningmessage = 240.0;
          enabled_message = Colors.green[300];
          setState(() {});
        }
      }
    }
  }

  double sendLeft = 10.0;

  send() {
    var formdata = formstate.currentState;
    if (formdata != null) {
      if (formdata.validate()) {
        AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          animType: AnimType.SCALE,
          dialogType: DialogType.NO_HEADER,
          body: Column(
            children: [
              Atom(
                size: 100,
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
              SizedBox(
                height: 15,
              ),
              Text(
                " ... يرجى الأنتظار",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ).show();
        formdata.save();
        contactus();
        sendLeft = 200;
        setState(() {});
      } else {
        enabled_message = Colors.red[300];
        enabled_email = Colors.red[300];
        _warningmessage = 35.0;
        _warningemail = 20;

        setState(() {});
      }
    }
  }

  setUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username") ?? "Username";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Change(9);
    setUsername();
    super.initState();
  }

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
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
        appBar: AppBar(
            brightness: Brightness.dark,
            title: AutoSizeText(
              "تواصل معنا",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        showdialog(context, "تواصل معنا", intro());
                      },
                      icon: FaIcon(FontAwesomeIcons.questionCircle)))
            ]),
        drawer: Mydrawer(),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/Contactus.png',
                    height: height * 0.4,
                    fit: BoxFit.fill,
                  ),
                  Form(
                      key: formstate,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 30, right: 30, bottom: 10, top: 0),
                        child: Column(
                          children: [
                            Consumer<UserData>(
                              builder: (context, userdata, child) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50.0, top: 20),
                                      child: AutoSizeText("$username",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: width < 330 ? 18 : 20,
                                              color: Colors.green)),
                                    ),
                                    TextFormField(
                                      initialValue: "",
                                      enabled: false,
                                      onSaved: (text) {
                                        username = text;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 25,
                                      maxLines: 2,
                                      minLines: 1,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(20),
                                          suffixIcon: Icon(
                                            Icons.check,
                                            color: Colors.green[300],
                                            size: width < 330 ? 35 : 40,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.account_circle_rounded,
                                            color: Colors.green[300],
                                            size: width < 330 ? 25 : 30,
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ))),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Container(
                              child: Stack(
                                children: [
                                  TextFormField(
                                    onSaved: (text) {
                                      email = text;
                                    },
                                    validator: (text) {
                                      if (text != null) {
                                        if (text.isEmpty ||
                                            !RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                                .hasMatch(text)) {
                                          return "يرجى أدخال بريد ألكتروني صالح";
                                        }
                                      }
                                    },
                                    onChanged: (text) {
                                      input_email = text;
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    onEditingComplete: error_email(input_email),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: "البريد الألكتروني",
                                        labelStyle:
                                            TextStyle(color: enabled_email),
                                        contentPadding: EdgeInsets.all(
                                            width < 330 ? 10 : 20),
                                        prefixIcon: Icon(
                                          Icons.email_rounded,
                                          color: enabled_email,
                                          size: width < 330 ? 25 : 30,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 4,
                                                color: enabled_email)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: enabled_email,
                                          width: 4,
                                        ))),
                                  ),
                                  AnimatedPositioned(
                                      duration: Duration(milliseconds: 700),
                                      right: _checkemail,
                                      top: 20,
                                      child: Icon(Icons.check,
                                          size: width < 330 ? 35 : 40,
                                          color: Colors.green)),
                                  AnimatedPositioned(
                                      duration: Duration(milliseconds: 700),
                                      right: 5,
                                      top: _warningemail,
                                      child: Icon(Icons.priority_high_rounded,
                                          size: width < 330 ? 35 : 40,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                TextFormField(
                                  onSaved: (text) {
                                    message = text;
                                  },
                                  validator: (text) {
                                    if (text != null) {
                                      if (text.length < 11) {
                                        return "الرسالة لا يمكن أن تكون اصغر من عشرة أحرف";
                                      }
                                    }
                                  },
                                  onChanged: (text) {
                                    input_message = text;
                                    setState(() {});
                                  },
                                  onEditingComplete:
                                      error_message(input_message),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.newline,
                                  minLines: 2,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                      labelText: "الرسالة",
                                      labelStyle:
                                          TextStyle(color: enabled_message),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: width < 330 ? 10 : 20,
                                          horizontal: 20),
                                      prefixIcon: Icon(
                                        Icons.message,
                                        color: enabled_message,
                                        size: width < 330 ? 25 : 30,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: enabled_message)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: enabled_message,
                                        width: 4,
                                      ))),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: _checkmessage,
                                    top: 40,
                                    child: Icon(Icons.check,
                                        size: width < 330 ? 35 : 40,
                                        color: Colors.green)),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: 5,
                                    top: _warningmessage,
                                    child: Icon(Icons.priority_high_rounded,
                                        size: width < 330 ? 35 : 40,
                                        color: Colors.red)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Consumer<ConnectivityProvider>(
                                builder: (context, online, child) {
                              return Container(
                                width: 120,
                                height: 50,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.blue.shade600,
                                      Colors.cyan.shade400
                                    ]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                    onTap: () {
                                      if (online.isOnline == true) {
                                        send();
                                      } else {
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
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        "contactus");
                                              }).show();
                                        } catch (e) {}
                                      }
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      child: Stack(
                                        children: [
                                          AnimatedPositioned(
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              top: 10,
                                              left: sendLeft,
                                              curve: Curves.elasticIn,
                                              child: Icon(Icons.send,
                                                  size: 30,
                                                  color: Colors.white)),
                                          Positioned(
                                            right: 20,
                                            top: 6,
                                            child: Text("أرسال",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            })
                          ],
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
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
          titleWidget: Image.asset("images/contact.png",
              fit: BoxFit.fitHeight, height: height * 0.4),
          bodyWidget: Container(),
          footer: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text("هذا القسم للتواصل معنا ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 700),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text("عن أي استفسار  مهما كان ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Contactus2.png",
          ),
          bodyWidget: Text(""),
          footer: Column(
            children: [
              DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text("يرجى كتابة بريد الكتروني صالح _",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 700),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text(
                    "الذي سيتم أرسال الرسالة منه"
                    "\n",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: responsiveFont, color: Color(0xff909295))),
              ),
              DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                animationDuration: Duration(milliseconds: 700),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Text(
                    "أكتب رسالتك مهما كانت _"
                    "\n"
                    "(أستفسار , تشجيع , نقد ,..ألخ)",
                    textAlign: TextAlign.right,
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
