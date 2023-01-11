import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubjectsInfo with ChangeNotifier {
  final version = 2;

  getSubjectInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/subject_info.php");
      var subjectInfoVersion =
          await prefs.getString("subjectInfoVersion") ?? "0";
      var response = await http.post(url, body: {
        "version": "$version",
        "subjectInfoVersion": "$subjectInfoVersion"
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      if (responsebody[1] != "your subjectInfoVersion is uptodate") {
        await prefs.setString("subjectInfoVersion", "${responsebody[1]}");
        await prefs.setString("subjectInfo", "${jsonEncode(responsebody)}");
      }

      if (responsebody[2] != "your app version is uptodate") {
        await prefs.setString("update", "${jsonEncode(responsebody[2])}");
      }

      var subjectInfo = await prefs.getString("subjectInfo");
      await setSubjects(subjectInfo);
    } catch (e) {
      try {
        final url = Uri.parse(
            "https://xpositronstore.000webhostapp.com/php/subject_info.php");
        var subjectInfoVersion =
            await prefs.getString("subjectInfoVersion") ?? "0";
        var response = await http.post(url, body: {
          "version": "$version",
          "subjectInfoVersion": "$subjectInfoVersion"
        });
        var responsebody = jsonDecode(response.body);

        if (responsebody[1] != "your subjectInfoVersion is uptodate") {
          await prefs.setString("subjectInfoVersion", "${responsebody[1]}");
          await prefs.setString("subjectInfo", "${jsonEncode(responsebody)}");
        }

        if (responsebody[2] != "your app version is uptodate") {
          await prefs.setString("update", "${jsonEncode(responsebody[2])}");
        }

        var subjectInfo = await prefs.getString("subjectInfo");
        await setSubjects(subjectInfo);
      } catch (e) {
        var subjectInfo = await prefs.getString("subjectInfo");
        await setSubjects(subjectInfo);
      }
    }
  }

  setSubjects(subjectInfo) async {
    try {
      List subjectInfoList = await json.decode(subjectInfo!);
      firstYear.clear();
      secondyear.clear();
      thirdyear.clear();
      forthyear.clear();
      fifthyear.clear();
      subjectInfoList = subjectInfoList[0];
      subjectInfoList.forEach((ele) {
        if (ele["year"] == "1") {
          firstYear.add(ele);
        } else if (ele["year"] == "2") {
          secondyear.add(ele);
        } else if (ele["year"] == "3") {
          thirdyear.add(ele);
        } else if (ele["year"] == "4") {
          forthyear.add(ele);
        } else if (ele["year"] == "5") {
          fifthyear.add(ele);
        }
      });
    } catch (e) {}
    notifyListeners();
  }

  getVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList("lastvisted1") != null) {
      vistedSubjects[0] = {
        "name": prefs.getStringList("lastvisted1")![0],
        "year": prefs.getStringList("lastvisted1")![1]
      };
    }
    if (prefs.getStringList("lastvisted2") != null) {
      vistedSubjects[1] = {
        "name": prefs.getStringList("lastvisted2")![0],
        "year": prefs.getStringList("lastvisted2")![1]
      };
    }
    if (prefs.getStringList("lastvisted3") != null) {
      vistedSubjects[2] = {
        "name": prefs.getStringList("lastvisted3")![0],
        "year": prefs.getStringList("lastvisted3")![1]
      };
    }
    if (prefs.getStringList("lastvisted4") != null) {
      vistedSubjects[3] = {
        "name": prefs.getStringList("lastvisted4")![0],
        "year": prefs.getStringList("lastvisted4")![1]
      };
    }
    if (prefs.getStringList("lastvisted5") != null) {
      vistedSubjects[4] = {
        "name": prefs.getStringList("lastvisted5")![0],
        "year": prefs.getStringList("lastvisted5")![1]
      };
    }

    return vistedSubjects;
  }

  List firstYear = [];
  List secondyear = [];
  List thirdyear = [];
  List forthyear = [];
  List fifthyear = [];

  List<Map> vistedSubjects = [
    {"name": "", "year": ""},
    {"name": "", "year": ""},
    {"name": "", "year": ""},
    {"name": "", "year": ""},
    {"name": "", "year": ""}
  ];
  vistedSubjectsfun(subjectName, year) async {
    if (checkContain(subjectName, year)) {
      if (vistedSubjects.contains({"name": "", "year": ""})) {
        for (int i = 0; i < 5; i++) {
          if (vistedSubjects[i] == {"name": "", "year": ""}) {
            vistedSubjects[i] = {"name": "$subjectName", "year": "$year"};
            break;
          }
        }
        refreshprefs();
      } else {
        vistedSubjects[0] = vistedSubjects[1];
        vistedSubjects[1] = vistedSubjects[2];
        vistedSubjects[2] = vistedSubjects[3];
        vistedSubjects[3] = vistedSubjects[4];
        vistedSubjects[4] = {"name": "$subjectName", "year": "$year"};

        refreshprefs();
      }
    }
    //if already exists
    else {
      var index;
      for (int i = 0; i < vistedSubjects.length; i++) {
        if (vistedSubjects[i]["name"] == subjectName &&
            vistedSubjects[i]["year"] == "$year") {
          index = i;
          break;
        }
      }

      if (index != null) {
        vistedSubjects.removeAt(index);
        vistedSubjects.add({"name": "$subjectName", "year": "$year"});
        refreshprefs();
      }
    }
  }

  bool checkContain(subjectName, year) {
    bool checkcontain = true;
    vistedSubjects.forEach((element) {
      if (element["name"] == subjectName || element["year"] == year) {
        checkcontain = false;
      }
    });
    return checkcontain;
  }

  refreshprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (vistedSubjects[0] != {"name": "", "year": ""}) {
      await prefs.setStringList("lastvisted1",
          [vistedSubjects[0]["name"], vistedSubjects[0]["year"]]);
    }
    if (vistedSubjects[1] != {"name": "", "year": ""}) {
      await prefs.setStringList("lastvisted2",
          [vistedSubjects[1]["name"], vistedSubjects[1]["year"]]);
    }
    if (vistedSubjects[2] != {"name": "", "year": ""}) {
      await prefs.setStringList("lastvisted3",
          [vistedSubjects[2]["name"], vistedSubjects[2]["year"]]);
    }
    if (vistedSubjects[3] != {"name": "", "year": ""}) {
      await prefs.setStringList("lastvisted4",
          [vistedSubjects[3]["name"], vistedSubjects[3]["year"]]);
    }
    if (vistedSubjects[4] != {"name": "", "year": ""}) {
      await prefs.setStringList("lastvisted5",
          [vistedSubjects[4]["name"], vistedSubjects[4]["year"]]);
    }
  }
}
