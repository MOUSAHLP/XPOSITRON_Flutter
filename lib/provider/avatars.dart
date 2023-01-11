import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Avatars extends StatefulWidget {
  final Map avatars;
  final List avatarsKeys;
  Avatars({Key? key, required this.avatars, required this.avatarsKeys})
      : super(key: key);

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  List<int> activeIndexList = [];

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

  var imagePath;
  var userName;

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("username");
    if (prefs.containsKey("image")) {
      imagePath = prefs.getString("image");
    }
    setState(() {});
  }

  @override
  void initState() {
    activeIndexList = List.filled(widget.avatarsKeys.length, 0);
    shared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setAvatars(imagePath);
        Navigator.of(context).pop(imagePath);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: 150,
                color: Colors.blue.shade700,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                  imagePath ??
                                      "https://xpositronstore.000webhostapp.com/images/defultImage.png"),
                            ),
                            AutoSizeText(
                              userName ?? "",
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                    ),
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(60))),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(60))),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.avatarsKeys.length,
                    itemBuilder: ((context, index) {
                      PageController _pageController = PageController();

                      return Container(
                        height: 150,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                right: 20,
                              ),
                              child: AutoSizeText(
                                widget.avatarsKeys[index],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                children: [
                                  ...List.generate(
                                      manyPageView(widget
                                          .avatars[widget.avatarsKeys[index]]
                                          .length), (i) {
                                    return Row(
                                      children: [
                                        ...List.generate(4, (j) {
                                          var counter = j + 4 * i;
                                          if (counter >=
                                              widget
                                                  .avatars[
                                                      widget.avatarsKeys[index]]
                                                  .length) {
                                            return Expanded(child: Container());
                                          }
                                          return Expanded(
                                              child: cachedImage(widget.avatars[
                                                      widget.avatarsKeys[index]]
                                                  [counter]));
                                        })
                                      ],
                                    );
                                  })
                                ],
                                onPageChanged: (currIndex) {
                                  activeIndexList[index] = currIndex;
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            // the dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...List.generate(
                                    manyPageView(widget
                                        .avatars[widget.avatarsKeys[index]]
                                        .length), (k) {
                                  return InkWell(
                                    child: AnimatedScale(
                                      scale: activeIndexList[index] == k
                                          ? 1.2
                                          : .8,
                                      duration: Duration(milliseconds: 300),
                                      child: AnimatedOpacity(
                                        opacity: activeIndexList[index] == k
                                            ? 1
                                            : .5,
                                        duration: Duration(milliseconds: 300),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      _pageController.animateToPage(k,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeOut);
                                    },
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  cachedImage(img) {
    try {
      return InkWell(
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
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("image", img);
            imagePath = img;
            setState(() {});
          });
    } catch (e) {
      return Center(
        child: AutoSizeText("فشل في تحميل الصورة"),
      );
    }
  }

  manyPageView(int length) {
    int finalNum = length ~/ 4;
    if (length % 4 != 0) {
      finalNum++;
    }
    return finalNum;
  }
}
