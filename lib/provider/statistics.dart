import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Statistics with ChangeNotifier {
  var likes;
  var love_precentage;
  var love_precentage_center;
  var hard_precentage;
  var hard_precentage_center;
  var isliked;
  var userlove;
  var userhard;
  var rate;
  var rateval;

  // Statistics([var id, String subject]) {
  //   statistics(id, subject);
  // }

  Future statistics(var id, String subject) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/statistics_flutter.php");

      var response = await http.post(url, body: {
        "user_id": "$id",
        "subject": subject,
      });
      var responsebody = jsonDecode(response.body);

      if (responsebody['subject'] == subject) {
        likes = responsebody['likes'];
        love_precentage = responsebody['love_precentage'];
        love_precentage_center = responsebody['love_precentage_center'];
        hard_precentage = responsebody['hard_precentage'];
        hard_precentage_center = responsebody['hard_precentage_center'];
        isliked = responsebody['isliked'];
        userlove = responsebody['userlove'];
        userhard = responsebody['userhard'];
      }
    } catch (e) {}
  }

  Future slider(var id, var subject, var _rate, var _rateval, var context,
      var route) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/user_statistics_flutter.php");

      var response = await http.post(url,
          body: {"user_id": id, "subject": subject, "$_rate": "$_rateval"});
      var responsebody = jsonDecode(response.body);

      if (responsebody['succeeded'] == "done") {
        rate = _rate;
        rateval = _rateval;
      }
    } catch (m) {
      if (m ==
          "I/flutter (16794): SocketException: Failed host lookup: 'xpositron.000webhostapp.com' (OS Error: No address associated with hostname, errno = 7)") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'error',
          desc:
              'Something went wrong \n\n Please check your internet \n and try again',
          btnCancelText: "back",
          btnCancelOnPress: () {
            Navigator.of(context).pushReplacementNamed(route);
          },
        )..show();
      }
    }
    statistics(id, subject);
    notifyListeners();
  }
}
