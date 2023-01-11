import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/provider/avatars.dart';

class ChosseAvatar extends StatefulWidget {
  ChosseAvatar({Key? key}) : super(key: key);

  @override
  State<ChosseAvatar> createState() => _ChosseAvatarState();
}

class _ChosseAvatarState extends State<ChosseAvatar> {
  static Map avatars = {};
  static List avatarsKeys = [];
  static List randomAvatars = [];

  Future getAvatars() async {
    try {
      final url =
          Uri.parse("https://xpositronstore.000webhostapp.com/getAvatars.php");

      var response = await http.post(url, body: {
        "send": "send",
      });
      var responsebody = jsonDecode(response.body);
      avatars.clear();
      avatars.addAll(responsebody);
      avatarsKeys.clear();
      avatarsKeys.addAll(avatars.keys.toList());

      print(responsebody);

      randomAvatars.clear();
      randomImages();

      setState(() {});
    } catch (e) {}
  }

  Future setAvatars(img) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/setAvatars.php");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = await prefs.getString("id");
      var response = await http.post(url, body: {
        "id": id,
        "image": img,
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getAvatars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: height * .35,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: double.infinity,
              child: AutoSizeText("أختر الأيقونة المناسبة لك",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: width < 330
                          ? 20
                          : width > 400
                              ? 30
                              : 25,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 10,
            ),
            avatars.isNotEmpty && randomAvatars.isNotEmpty
                ? Row(children: [
                    ...List.generate(
                      4,
                      (index) => Expanded(
                        flex: 1,
                        child: cachedImage(randomAvatars[index]),
                      ),
                    ),
                  ])
                : Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText("يتم تحميل الصور")
                    ],
                  ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      "المزيد",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: avatars.isNotEmpty && randomAvatars.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: avatars.isNotEmpty && randomAvatars.isNotEmpty
                          ? Colors.blue
                          : Colors.grey,
                    )
                  ],
                ),
              ),
              onTap: () {
                if (avatars.isNotEmpty && randomAvatars.isNotEmpty)
                  Navigator.of(context)
                      .push(AnimateSlider(
                          Page: Avatars(
                              avatars: avatars, avatarsKeys: avatarsKeys),
                          start: 1.0,
                          finish: 0.0))
                      .then((value) {
                    Navigator.of(context).pop(value);
                  });
              },
            ),
          ],
        ),
      ),
    );
    ;
  }

  cachedImage(img) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: CachedNetworkImage(
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
        ),
      ),
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("image", img);
        setAvatars(img);
        Navigator.of(context).pop(img);
      },
    );
  }

  randomImages() {
    Random rndNum = Random();
    for (int i = 0; i < 4; i++) {
      String key = avatarsKeys[rndNum.nextInt(avatarsKeys.length)];
      String img = avatars[key][rndNum.nextInt(avatars[key].length)];
      if (randomAvatars.contains(img)) {
        i--;
        continue;
      } else {
        randomAvatars.add(img);
      }
    }
  }
}
