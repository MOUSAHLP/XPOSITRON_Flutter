import 'package:auto_size_text/auto_size_text.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

gotologin(bool log) {
  if (log == true) {
    return true;
  }
  return false;
}

class Signup extends StatefulWidget with ChangeNotifier {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  var f;
  List posts = [];
  Future signup() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/get_flutter.php");

      var response = await http.post(url, body: {
        "username": "$username",
        "password": "$password",
        "year": "$year"
      });
      var responsebody = await jsonDecode(response.body);

      if (responsebody['response'] == 'alredy exist') {
        Navigator.of(context).pop();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.SCALE,
          title: 'خطأ',
          desc: 'هذا الحساب موجود بالفعل ',
          btnCancelText: "عودة",
          btnCancelOnPress: () {},
        ).show();
      } else if (responsebody['response'] == 'Insert succeeded') {
        Navigator.of(context).pop();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", responsebody['id']);
        await prefs.setString("username", username);
        await prefs.setString("password", password);
        await prefs.setInt("year", year);
        await prefs.setString("date", responsebody['date']);

        Navigator.of(context).pushReplacement(AnimateScale(Page: MyApp()));
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

  var year;
  Color year1 = Colors.blue;
  Color year2 = Colors.blue;
  Color year3 = Colors.blue;
  Color year4 = Colors.blue;
  Color year5 = Colors.blue;

  Color enabled_year = Colors.blue;

  selectedItem(var y) {
    resetYearColor(var r) {
      switch (y) {
        case 1:
          year2 = Colors.blue;
          year3 = Colors.blue;
          year4 = Colors.blue;
          year5 = Colors.blue;

          break;

        case 2:
          year1 = Colors.blue;
          year3 = Colors.blue;
          year4 = Colors.blue;
          year5 = Colors.blue;

          break;

        case 3:
          year2 = Colors.blue;
          year1 = Colors.blue;
          year4 = Colors.blue;
          year5 = Colors.blue;

          break;

        case 4:
          year2 = Colors.blue;
          year3 = Colors.blue;
          year1 = Colors.blue;
          year5 = Colors.blue;

          break;

        case 5:
          year2 = Colors.blue;
          year3 = Colors.blue;
          year4 = Colors.blue;
          year1 = Colors.blue;

          break;
      }
    }

    switch (y) {
      case 1:
        year1 = Colors.green;
        resetYearColor(1);
        return Colors.green;

      case 2:
        year2 = Colors.green;
        resetYearColor(2);
        return Colors.green;

      case 3:
        year3 = Colors.green;
        resetYearColor(3);
        return Colors.green;

      case 4:
        year4 = Colors.green;
        resetYearColor(4);
        return Colors.green;

      case 5:
        year5 = Colors.green;
        resetYearColor(5);
        return Colors.green;

      default:
        return Colors.blue;
    }
  }

  var username;
  var inputName = "";
  var enabledName;
  double _checkname = -40.0;
  double _warningname = 120.0;

  regexpName(String iv) {
    if (iv.length != 0) {
      if (!RegExp(r'^[a-z A-Z]+$').hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  errorName(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabledName == null && iv.length == 0) {
        enabledName = Colors.blue;
      }
      if (iv.length == 1 || iv.length == 2 || regexpName(iv)) {
        _checkname = -40.0;
        _warningname = 18;
        enabledName = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkname = 10;
          _warningname = 120.0;
          enabledName = Colors.green[300];
        }
      }
    }
  }

  var password;
  var inputPassword = "";
  var enabledPassword;
  double _checkpassword = -70.0;
  double _warningpassword = 120.0;

  regexpPassword(String iv) {
    if (iv.length != 0) {
      if (!RegExp(r'^[a-z A-Z 0-9]+$').hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  errorPassword(String iv) {
    if (iv != null || iv.length != 0) {
      if (enabledPassword == null && iv.length == 0) {
        enabledPassword = Colors.blue;
      }
      if ((iv.length > 0 && iv.length < 4) || regexpPassword(iv)) {
        _checkpassword = -70.0;
        _warningpassword = 18;
        enabledPassword = Colors.red[300];
      } else {
        if (iv.length != 0) {
          _checkpassword = 10.0;
          _warningpassword = 120.0;
          enabledPassword = Colors.green[300];
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
              Text(
                " ... يرجى الأنتظار",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        )..show();
        formdata.save();

        signup();
      } else {
        _warningname = 18;
        enabledName = Colors.red[300];

        _warningpassword = 18;
        enabledPassword = Colors.red[300];

        enabled_year = Colors.red.shade300;
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
                                    inputName = text;
                                    setState(() {});
                                  },
                                  onEditingComplete: errorName(inputName),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 20,
                                  maxLines: 2,
                                  minLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "اسم المستخدم",
                                      labelStyle: TextStyle(
                                          color: enabledName,
                                          fontSize: width < 350 ? 15 : 20),
                                      contentPadding:
                                          EdgeInsets.all(width < 350 ? 10 : 15),
                                      prefixIcon: Icon(
                                        Icons.account_circle_rounded,
                                        color: enabledName,
                                        size: width < 350 ? 25 : 30,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: enabledName,
                                      )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: enabledName,
                                        width: 2,
                                      ))),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: _checkname,
                                    top: 18,
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
                                    inputPassword = text;
                                    setState(() {});
                                  },
                                  onEditingComplete:
                                      errorPassword(inputPassword),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 12,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: "كلمة السر",
                                      labelStyle: TextStyle(
                                          color: enabledPassword,
                                          fontSize: width < 350 ? 15 : 20),
                                      contentPadding:
                                          EdgeInsets.all(width < 350 ? 10 : 15),
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: enabledPassword,
                                        size: width < 350 ? 25 : 30,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: enabledPassword)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: enabledPassword,
                                        width: 2,
                                      ))),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(milliseconds: 700),
                                    right: _checkpassword,
                                    top: 18,
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
                            DropdownButtonFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (text) {
                                year = text;
                              },
                              validator: (val) {
                                if (val == null) {
                                  return "يرجى أختيار السنة";
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: selectedItem(year),
                                  width: 2,
                                )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: selectedItem(year),
                                  width: 2,
                                )),
                              ),
                              hint: Container(
                                padding: EdgeInsets.only(left: 10, bottom: 0),
                                child: Row(children: [
                                  Icon(
                                    Icons.touch_app_rounded,
                                    color: enabled_year,
                                    size: width < 350 ? 25 : 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("أختر السنة",
                                      style: TextStyle(
                                          color: enabled_year,
                                          fontSize: width < 350 ? 15 : 20)),
                                ]),
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.looks_one_rounded,
                                      color: year1,
                                      size: width < 350 ? 25 : 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("السنة الأولى",
                                        style: TextStyle(color: year1)),
                                  ]),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.looks_two_rounded,
                                      color: year2,
                                      size: width < 350 ? 25 : 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("السنة الثانية",
                                        style: TextStyle(color: year2)),
                                  ]),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.looks_3_rounded,
                                      color: year3,
                                      size: width < 350 ? 25 : 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("السنة الثالثة",
                                        style: TextStyle(color: year3)),
                                  ]),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.looks_4_rounded,
                                      color: year4,
                                      size: width < 350 ? 25 : 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("السنة الرابعة",
                                        style: TextStyle(color: year4)),
                                  ]),
                                  value: 4,
                                ),
                                DropdownMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.looks_5_rounded,
                                      color: year5,
                                      size: width < 350 ? 25 : 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("السنة الخامسة",
                                        style: TextStyle(color: year5)),
                                  ]),
                                  value: 5,
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  year = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
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
                                      "انشاء حساب",
                                      style: TextStyle(
                                          fontSize: width < 350 ? 15 : 20,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )))
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
