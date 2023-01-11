import 'package:auto_size_text/auto_size_text.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  List posts = [];

  Future login() async {
    final url = Uri.parse(
        "https://xpositron.000webhostapp.com/flutter/login_flutter.php");
    try {
      var response = await http.post(url, body: {
        "username": "$username",
        "password": "$password",
      });
      var responsebody = jsonDecode(response.body);

      if (responsebody['response'] == 'alredy exist') {
        Navigator.of(context).pop();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", responsebody['id']);
        await prefs.setString("username", username);
        await prefs.setString("password", password);
        await prefs.setString("year", responsebody['year']);
        await prefs.setString("date", responsebody['date']);

        Navigator.of(context).pushReplacement(AnimateScale(Page: MyApp()));
      } else if (responsebody['response'] == 'not found') {
        Navigator.of(context).pop();

        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'خطأ',
          desc:
              'كلمة المرور أو اسم المستخدم غير صحيح \n يرجى التأكد من صحة البيانات',
          btnCancelText: "عودة",
          btnCancelOnPress: () {},
        ).show();
      }
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
                btnOkOnPress: () {})
            .show();
      } catch (e) {}
    }
  }

  var username;
  var input_text = "";
  var enabled_text;
  double _checkname = -70.0;
  double _warningname = 120.0;

  regexp_text(String iv) {
    if (iv.length != 0) {
      if (!RegExp(r'^[a-z A-Z]+$').hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  error_text(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabled_text == null && iv.length == 0) {
        enabled_text = Colors.blue;
      }
      if (iv.length == 1 || iv.length == 2 || regexp_text(iv)) {
        _checkname = -70.0;
        _warningname = 20;
        enabled_text = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkname = 10;
          _warningname = 120.0;
          enabled_text = Colors.green[300];
        }
      }
    }
  }

  var password;
  var input_password = "";
  var enabled_password;
  double _checkpassword = -70.0;
  double _warningpassword = 120.0;

  regexp_password(String iv) {
    if (iv.length != 0) {
      if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  error_password(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabled_password == null && iv.length == 0) {
        enabled_password = Colors.blue;
      }
      if ((iv.length > 0 && iv.length < 4) || regexp_password(iv)) {
        _checkpassword = -40.0;
        _warningpassword = 20;
        enabled_password = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkpassword = 10;
          _warningpassword = 120.0;
          enabled_password = Colors.green[300];
        }
      }
    }
  }

  send() {
    var formdata = formstate.currentState;
    if (formdata != null) {
      if (formdata.validate()) {
        AwesomeDialog(
          context: context,
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
              AutoSizeText(
                " ... يرجى الأنتظار",
                maxLines: 1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        )..show();
        formdata.save();

        login();
      } else {
        enabled_text = Colors.red[300];
        _warningname = 20;

        enabled_password = Colors.red[300];
        _warningpassword = 20;

        setState(() {});
      }
    }
  }

  @override
  void initState() {
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
        body: Container(
          color: Colors.white,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: formstate,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 30, right: 30, bottom: 10, top: 10),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                TextFormField(
                                  onSaved: (text) {
                                    username = text;
                                  },
                                  validator: (text) {
                                    if (text != null) {
                                      if (text.length < 3) {
                                        return "الأسم لا يمكن أن يكون اصغر من حرفين";
                                      }
                                      if (text.isEmpty ||
                                          !RegExp(r'^[a-z A-Z]+$')
                                              .hasMatch(text)) {
                                        return "يرجى أدخال الأحرف الأنكليزية فقط";
                                      }
                                    }
                                  },
                                  onChanged: (text) {
                                    input_text = text;
                                    setState(() {});
                                  },
                                  onEditingComplete: error_text(input_text),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 20,
                                  maxLines: 2,
                                  minLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "اسم المستخدم",
                                      labelStyle: TextStyle(
                                          color: enabled_text,
                                          fontSize: width < 350 ? 15 : 20),
                                      contentPadding:
                                          EdgeInsets.all(width < 350 ? 10 : 15),
                                      prefixIcon: Icon(
                                        Icons.account_circle_rounded,
                                        color: enabled_text,
                                        size: width < 350 ? 25 : 30,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: enabled_text,
                                      )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: enabled_text,
                                        width: 2,
                                      ))),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: _checkname,
                                    top: 20,
                                    child: Icon(Icons.check,
                                        size: 40, color: Colors.green)),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: 5,
                                    top: _warningname,
                                    child: Icon(Icons.priority_high_rounded,
                                        size: 40, color: Colors.red)),
                              ],
                            ),
                            Stack(
                              children: [
                                TextFormField(
                                  onSaved: (text) {
                                    password = text;
                                  },
                                  obscureText: true,
                                  validator: (text) {
                                    if (text != null) {
                                      if (text.length < 4) {
                                        return "كلمة المرور لا يمكن أن تكون اصغر من أربع أحرف";
                                      }
                                      if (text.isEmpty ||
                                          !RegExp(r'^[a-z A-Z 0-9]+$')
                                              .hasMatch(text)) {
                                        return "يرجى أدخال الأحرف الأنكليزية و الأرقام فقط";
                                      }
                                    }
                                  },
                                  onChanged: (text) {
                                    input_password = text;
                                    setState(() {});
                                  },
                                  onEditingComplete:
                                      error_password(input_password),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 12,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      labelText: "كلمة السر",
                                      labelStyle: TextStyle(
                                          color: enabled_password,
                                          fontSize: width < 350 ? 15 : 20),
                                      contentPadding:
                                          EdgeInsets.all(width < 350 ? 15 : 20),
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: enabled_password,
                                        size: width < 350 ? 25 : 30,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: enabled_password)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: enabled_password,
                                        width: 2,
                                      ))),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: _checkpassword,
                                    top: 25,
                                    child: Icon(Icons.check,
                                        size: 40, color: Colors.green)),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: 5,
                                    top: _warningpassword,
                                    child: Icon(Icons.priority_high_rounded,
                                        size: 40, color: Colors.red)),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  width: width * 0.4,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(colors: [
                                        Colors.blue.shade600,
                                        Colors.cyan.shade400
                                      ])),
                                  child: InkWell(
                                      onTap: () {
                                        send();
                                      },
                                      child: AutoSizeText(
                                        "تسجيل دخول",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: width < 350 ? 15 : 20,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ))),
                            )
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
}
