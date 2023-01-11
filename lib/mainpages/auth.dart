import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:x_positron/mainpages/login.dart';
import 'package:x_positron/mainpages/signup.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  PageController pagecontroller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  DateTime pre_backpress = DateTime.now();
  double _bottomLeft = 180.0;
  double _bottomRight = 0.0;
  Color signinColor = Colors.blue;
  Color loginColor = Colors.grey;
  double signinsize = 35;
  double loginsize = 16;
  FontWeight signinWeight = FontWeight.bold;
  FontWeight loginWeight = FontWeight.normal;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: WillPopScope(
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
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: height < 520 ? height * 0.35 : height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(_bottomLeft),
                          bottomRight: Radius.circular(_bottomRight)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.6,
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            "اهلا بك في",
                            style: TextStyle(
                                color: Colors.blue[200], fontSize: 25),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width < 350 ? width * 0.6 : width * 0.7,
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            "X-POSITRON",
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: 60,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: Container(
                              child: Image.asset(
                            "images/positron.png",
                            fit: BoxFit.fill,
                          )),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            pagecontroller.animateToPage(0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                            _bottomLeft = 180.0;
                            _bottomRight = 0.0;
                            signinColor = Colors.blue;
                            loginColor = Colors.grey;
                            signinsize = 35;
                            loginsize = 16;
                            loginWeight = FontWeight.normal;
                            signinWeight = FontWeight.bold;
                            setState(() {});
                          },
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.elasticOut,
                            style: TextStyle(
                                color: signinColor,
                                fontSize: signinsize,
                                fontWeight: signinWeight),
                            child: Container(
                              width: width * 0.3,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                "انشاء حساب",
                                maxLines: 1,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 40,
                      ),
                      TextButton(
                          onPressed: () {
                            pagecontroller.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                            _bottomLeft = 0.0;
                            _bottomRight = 180.0;
                            signinColor = Colors.grey;
                            loginColor = Colors.blue;
                            signinsize = 16;
                            loginsize = 35;
                            loginWeight = FontWeight.bold;
                            signinWeight = FontWeight.normal;
                            setState(() {});
                          },
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.elasticOut,
                            style: TextStyle(
                                color: loginColor,
                                fontSize: loginsize,
                                fontWeight: loginWeight),
                            maxLines: 1,
                            child: Container(
                              width: width * 0.3,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                "تسجيل دخول",
                              ),
                            ),
                          )),
                    ],
                  ),
                  Container(
                    width: width,
                    height: height - (height * 0.35),
                    child: PageView(
                      controller: pagecontroller,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Signup(),
                        Login(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
