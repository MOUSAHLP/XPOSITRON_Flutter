import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/auth.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction>
    with TickerProviderStateMixin {
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    double responsiveSText = width < 330
        ? 30
        : width > 400
            ? 40
            : 35;
    double responsiveSubText = width < 330
        ? 16
        : width > 400
            ? 22
            : 18;
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
                content: AutoSizeText(
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
          child: IntroductionScreen(
            globalBackgroundColor: Colors.white,
            pages: [
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("X-POSITRON",
                      style: TextStyle(
                          fontSize: responsiveSText,
                          color: Colors.yellow.shade700,
                          fontWeight: FontWeight.bold)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/atom.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText(
                          "X-POSITRON اهلا بك في"
                          "\n",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 700),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText(
                          "المرجع الأول في قسم هندسة الأتصالات والألكترون"
                          "\n"
                          "تعرف على كل مواد القسم",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    )
                  ],
                ),
              ),
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("الاحصائيات",
                      style: TextStyle(
                          fontSize: responsiveSText, color: Colors.black)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/statistics.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText("قيم جميع موادك المفضلة ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                        delayDuration: Duration(milliseconds: 700),
                        animationDuration: Duration(milliseconds: 700),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: AutoSizeText(
                            "  في قسم هندسة الأتصالات والألكترون",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveSubText,
                                color: Color(0xff909295)))),
                  ],
                ),
              ),
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("التحميلات",
                      style: TextStyle(
                          fontSize: responsiveSText, color: Colors.black)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/download.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText(
                          "حمل الملفات"
                          "\n"
                          "محاضرات , كتب ,دورات , ملفات أضافية",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                        delayDuration: Duration(milliseconds: 700),
                        animationDuration: Duration(milliseconds: 700),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: AutoSizeText(
                            " مع العلم ان الروابط تتحدث كل سنة تلقائيا",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveSubText,
                                color: Color(0xff909295)))),
                  ],
                ),
              ),
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("الأسئلة الشائعة",
                      style: TextStyle(
                          fontSize: responsiveSText, color: Colors.black)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/question.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText("جميع أسئلتك حول الجامعة ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                        delayDuration: Duration(milliseconds: 700),
                        animationDuration: Duration(milliseconds: 700),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: AutoSizeText(
                            "وحول النظام التدريسي تجد اجابتها هنا",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveSubText,
                                color: Color(0xff909295)))),
                  ],
                ),
              ),
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("الاعلانات",
                      style: TextStyle(
                          fontSize: responsiveSText, color: Colors.black)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/postIntro.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText("شارك أفكارك معنا ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                        delayDuration: Duration(milliseconds: 700),
                        animationDuration: Duration(milliseconds: 700),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: AutoSizeText(
                            "X-POSITON الان اصبح موقع تواصل اجتماعي",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: responsiveSubText,
                                color: Color(0xff909295)))),
                  ],
                ),
              ),
              PageViewModel(
                titleWidget: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: AutoSizeText("تسجيل الدخول",
                      style: TextStyle(
                          fontSize: responsiveSText, color: Colors.black)),
                ),
                bodyWidget: Column(
                  children: [
                    Image.asset("images/auth.png", height: height * 0.5),
                    DelayedWidget(
                      delayDuration: Duration(milliseconds: 400),
                      animationDuration: Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: AutoSizeText("قبل البدء يجب تسجيل الدخول ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsiveSubText,
                              color: Color(0xff909295))),
                    ),
                    DelayedWidget(
                        delayDuration: Duration(milliseconds: 700),
                        animationDuration: Duration(milliseconds: 700),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: AutoSizeText(
                            "ملاحظة :اذا كان لديك  حساب في موقعنا \n فلا يوجد داع لأنشاء حساب جديد",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveSubText,
                                color: Color(0xff909295)))),
                  ],
                ),
              ),
            ],
            onDone: () {
              Navigator.of(context).pushReplacement(AnimateScale(Page: Auth()));
            },
            dotsFlex: width < 330 ? 3 : 2,
            done: AutoSizeText("البدء",
                style: TextStyle(
                  fontSize: responsiveSubText,
                )),
            showNextButton: true,
            next: AutoSizeText("التالي",
                style: TextStyle(
                  fontSize: responsiveSubText,
                )),
            animationDuration: 700,
            curve: Curves.easeOut,
          ),
        ));
  }
}
