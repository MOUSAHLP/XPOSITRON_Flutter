import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier {
  var id;
  var username;
  var password;
  var year;
  var date;

  UserData() {
    setdata();
  }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString("id");
    username = await (prefs.getString("username") ?? null);
    password = prefs.getString("password");
    // year = prefs.getString("year");
    date = prefs.getString("date");
    notifyListeners();
  }
}
