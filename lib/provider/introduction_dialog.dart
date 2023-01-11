import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

showdialog(context, title, IntroductionScreen intro) {
  try {
    return showDialog(
        barrierDismissible: true,
        useRootNavigator: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text("$title"),
                content: intro,
              );
            }),
          );
        });
  } catch (e) {}
}
