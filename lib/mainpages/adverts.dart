import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/provider/addPost.dart';
import 'package:x_positron/provider/comments.dart';
import 'package:x_positron/provider/galleryWidget.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import '../provider/connectivity.dart';
import '../provider/offline.dart';
import '../provider/refresh.dart';
import '../provider/skeleton.dart';
import 'drawer.dart';

class Adverts extends StatefulWidget {
  @override
  _AdvertsState createState() => _AdvertsState();
}

class _AdvertsState extends State<Adverts>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static List advertsbody = [];
  static List userLikes = [];
  static List<bool> postAtom = [];
  static List isExpand = List.filled(1000, false);
  static List postTypes = [
    "الكل",
    "X-POSITRON",
    "اعلان",
    "بيع أو شراء",
    "مشروع",
    "طلب خدمة",
    "رأي",
    "اخرى"
  ];
  static List isSorted = [];
  String filter = "الكل";
  bool fixed = false;
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  final _listViewController = ScrollController();
  int newPostsLength = 0;

  Future getAdverts() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/posts/getPosts.php");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString("id");

      var response = await http.post(url, body: {
        "send": "send",
        "id": id,
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      int oldAdvertsLength = advertsbody.length;
      advertsbody.clear();
      advertsbody.addAll(responsebody["body"]);

      if (oldAdvertsLength > 0 &&
          oldAdvertsLength < responsebody["body"].length) {
        newPostsLength = responsebody["body"].length - oldAdvertsLength;
      }

      userLikes.clear();
      userLikes.addAll(responsebody["userLikes"]);

      postAtom = List.filled(1000, false);
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
            btnOkOnPress: () {
              getAdverts();
            }).show();
      } catch (e) {}
    }

    setState(() {});
  }

  setLike(postId) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/posts/setLike.php");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString("id");
      var response = await http.post(url, body: {
        "userId": id,
        "postId": postId,
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      getAdverts();
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  deletePost(postId) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/posts/deletePost.php");

      var response = await http.post(url, body: {
        "postId": postId,
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);

      if (responsebody["done"] == "done") {
        advertsbody.removeWhere((element) => element["id"] == postId);
        final snack = SnackBar(
          content: Text(
            "تم حذف المنشور بنجاح",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  getTime(date) {
    date = DateTime.parse(date);
    var difference = DateTime.now().difference(date);
    if (difference.inSeconds < 60) {
      return "منذ "
          " ${difference.inSeconds} "
          " من الثوان";
    } else if (difference.inMinutes < 60) {
      return "منذ "
          " ${difference.inMinutes} "
          " من  الدقائق";
    } else if (difference.inHours < 24) {
      return "منذ "
          " ${difference.inHours} "
          " من الساعات";
    } else if (difference.inDays < 7) {
      return "منذ "
          " ${difference.inDays} "
          " من الأيام";
    } else if (difference.inDays <= 29) {
      return "منذ "
          " ${difference.inDays ~/ 7} "
          " من الأسابيع";
    } else if (difference.inDays > 29 && difference.inDays <= 330) {
      return "منذ "
          " ${difference.inDays ~/ 30} "
          " من الاشهر";
    }

    return "منذ "
        " ${difference.inDays / 365} "
        "سنة ";
  }

  var id;
  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString("id");
  }

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      getAdverts();
    }
    getuserid();

    Change(10);
    isSorted = List.filled(postTypes.length, false);
    isSorted[0] = true;
    super.initState();
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  DateTime preBackpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(preBackpress);
          final cantExit = timegap >= Duration(seconds: 2);
          preBackpress = DateTime.now();
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
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: AutoSizeText(
                  "الاعلانات",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            showdialog(context, "الاعلانات", intro());
                          },
                          icon: FaIcon(FontAwesomeIcons.questionCircle)))
                ]),
            drawer: Mydrawer(),
            floatingActionButton: Column(
              children: [
                Spacer(),
                if (newPostsLength > 0)
                  InkWell(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.7),
                              borderRadius: BorderRadius.circular(5)),
                          child: AutoSizeText(
                            " $newPostsLength "
                            " منشور جديد",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _listViewController.animateTo(0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      newPostsLength = 0;
                      setState(() {});
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  tooltip: "نشر منشور",
                  onPressed: () {
                    var clonePostTypes =
                        postTypes.getRange(2, postTypes.length);

                    Navigator.of(context)
                        .push(AnimateSlider(
                            Page: AddPost(postTypes: clonePostTypes.toList()),
                            start: 1.0,
                            finish: 0.0))
                        .then((value) => getAdverts());
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            body: Consumer<ConnectivityProvider>(
                builder: (context, online, child) {
              if (online.isOnline == false) {
                return RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: getAdverts,
                    child: Offline());
              }
              if (online.isOnline == true) {
                return advertsbody.isEmpty
                    ? RefreshWidget(
                        keyRefresh: keyRefresh,
                        onRefresh: () async {
                          newPostsLength = 0;
                          getAdverts();
                        },
                        child: advertsSkeleton())
                    : RefreshWidget(
                        keyRefresh: keyRefresh,
                        onRefresh: () async {
                          newPostsLength = 0;
                          getAdverts();
                        },
                        child: Column(
                          children: [
                            fixedSort(),
                            Expanded(
                              child: ListView.builder(
                                  controller: _listViewController,
                                  itemCount: advertsbody.length,
                                  itemBuilder: (context, i) {
                                    return filter == "الكل"
                                        ? post(
                                            i: i,
                                            postId: advertsbody[i]["id"],
                                            userId: advertsbody[i]["id_user"],
                                            userName: advertsbody[i]
                                                ["username"],
                                            userImage: advertsbody[i]
                                                ["userImage"],
                                            feedTime: advertsbody[i]["date"],
                                            type: advertsbody[i]["type"],
                                            feedText: advertsbody[i]["text"],
                                            feedImage: advertsbody[i]["image"],
                                            likes: advertsbody[i]["likes"],
                                            comments: advertsbody[i]
                                                ["comments"],
                                            verified: advertsbody[i]
                                                ["verified"])
                                        : filter == advertsbody[i]["type"]
                                            ? post(
                                                i: i,
                                                postId: advertsbody[i]["id"],
                                                userName: advertsbody[i]
                                                    ["username"],
                                                userImage: advertsbody[i]
                                                    ["userImage"],
                                                feedTime: advertsbody[i]
                                                    ["date"],
                                                type: advertsbody[i]["type"],
                                                feedText: advertsbody[i]
                                                    ["text"],
                                                feedImage: advertsbody[i]
                                                    ["image"],
                                                likes: advertsbody[i]["likes"],
                                                comments: advertsbody[i]
                                                    ["comments"],
                                                verified: advertsbody[i]
                                                    ["verified"])
                                            : Container();
                                  }),
                            ),
                          ],
                        ));
              }
              return listViewSkeleton();
            })));
  }

  Widget fixedSort() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: fixed ? null : 0,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  ": فرز حسب النوع ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                types(),
              ],
            ),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: 30,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                )
              ],
            ),
            onTap: () {
              fixed = !fixed;

              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget types() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: postTypes.length,
          itemBuilder: (context, i) {
            return InkWell(
              child: AnimatedScale(
                duration: Duration(milliseconds: 700),
                scale: isSorted[i] == true ? 1.2 : 1,
                curve: Curves.elasticOut,
                child: Container(
                    padding: EdgeInsets.all(7),
                    margin: isSorted[i] == true
                        ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                        : EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        color: isSorted[i] == true
                            ? Colors.white
                            : Color(0xff10cab7),
                        borderRadius: BorderRadius.circular(10)),
                    child: AutoSizeText(
                      postTypes[i],
                      style: TextStyle(
                          color: isSorted[i] == true
                              ? Color(0xff10cab7)
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              onTap: () {
                isSorted = List.filled(postTypes.length, false);
                isSorted[i] = true;
                filter = postTypes[i];

                _listViewController.jumpTo(
                  0,
                );

                setState(() {});
              },
            );
          }),
    );
  }

  Widget post(
      {i,
      postId,
      userId,
      userName,
      userImage,
      feedTime,
      type,
      feedText,
      feedImage,
      likes,
      comments,
      verified}) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: userImage != ""
                          ? cachedImage(userImage)
                          : Icon(Icons.person),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AutoSizeText(
                              userName,
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: userName.length >= 19 ? 14 : 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            verified == "1"
                                ? Icon(
                                    Icons.verified_rounded,
                                    color: Colors.blue,
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              getTime(feedTime),
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xff19cab7),
                                  borderRadius: BorderRadius.circular(10)),
                              child: AutoSizeText(
                                type,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                more(postId, userId)
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          expandedText(i: i, text: feedText, image: feedImage),
          SizedBox(
            height: 20,
          ),
          displayImage(i, feedImage),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  " تعليقات : " + comments,
                  style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                ),
                Row(
                  children: [
                    AutoSizeText(
                      likes,
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    makeLike(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              makeCommentButton(likes, postId),
              makeLikeButton(i, postId),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 0.5,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget displayImage(i, List images) {
    return images.length != 0
        ? Container(
            height: 200,
            child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) => GalleryWidget(
                                  imagesUrl: images.toList(),
                                  index: i,
                                )));
                      },
                      child: images.length != 1
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: cachedImage(images[i]))
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              child: cachedImage(images[i])));
                }),
          )
        : Container();
  }

  cachedImage(String img) {
    return CachedNetworkImage(
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
    );
  }

  Widget makeLike() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLikeButton(i, postId) {
    bool isActive = userLikes.any((element) => element["post_id"] == postId);

    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (postAtom[i])
                Atom(
                  size: 30,
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
                width: 5,
              ),
              Icon(
                Icons.thumb_up,
                color: isActive ? Colors.blue : Colors.grey,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              AutoSizeText(
                "اعجاب",
                style: TextStyle(
                    color: isActive ? Colors.blue : Colors.grey, fontSize: 18),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        postAtom[i] = true;
        setState(() {});
        setLike(postId);
      },
    );
  }

  Widget makeCommentButton(_likes, postId) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat, color: Colors.grey, size: 18),
              SizedBox(
                width: 5,
              ),
              AutoSizeText(
                "التعليقات",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(AnimateSlider(
                Page: Comments(likes: _likes, postId: postId),
                start: 0.0,
                finish: 1.0))
            .then((value) {
          setState(() {
            var post = advertsbody.firstWhere((element) {
              return element["id"] == postId;
            });
            int index = advertsbody.indexOf(post);
            advertsbody[index]["comments"] = value.toString();
          });
        });
      },
    );
  }

  more(postId, userId) {
    bool isUser = userId == id;
    return Container(
      margin: EdgeInsets.all(10),
      child: PopupMenuButton(
          tooltip: "المزيد",
          offset: Offset(10.0, 50.0),
          padding: EdgeInsets.all(10),
          color: Colors.white,
          enableFeedback: true,
          child: Container(
            child: Icon(
              Icons.more_horiz,
              size: 30,
              color: Colors.grey[600],
            ),
          ),
          itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    tileColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.delete,
                            color: isUser ? Colors.red : Colors.grey),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "حذف المنشور ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: isUser ? Colors.black : Colors.grey,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (isUser) {
                        deletePost(postId);
                      } else {
                        final snack = SnackBar(
                          content: Text(
                            "هذه الخاصية متاحة فقط لصاحب المنشور",
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    tileColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ابلاغ",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () {
                      final snack = SnackBar(
                        content: Text(
                          "تم الابلاغ عن هذا المنشور"
                          "\n"
                          "سوف يتم مراجعة هذا المنشور",
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ]),
    );
  }

  Widget expandedText({i, text, image}) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.rtl,
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: 15, height: 1.5, letterSpacing: .7)));
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 20);

    List boxes = textPainter.computeLineMetrics();

    int rowsLimit = 8;
    if (image.length > 0) {
      rowsLimit = 5;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            Container(
              height: boxes.length < rowsLimit
                  ? null
                  : isExpand[i]
                      ? null
                      : image.length > 0
                          ? 50
                          : 165,
              child: Linkify(
                text: text,
                maxLines: 1000,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.5,
                    letterSpacing: .7),
                onOpen: (link) async {
                  print(" ======================");
                  print(link);
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(
                      Uri.parse(link.url),
                      mode: LaunchMode.externalApplication,
                      webViewConfiguration: const WebViewConfiguration(
                          enableDomStorage: true, enableJavaScript: true),
                    );
                  } else {
                    print('Could not launch $link');
                  }
                },
              ),
            ),
            InkWell(
              child: Row(
                children: [
                  AutoSizeText(
                      boxes.length < rowsLimit
                          ? ""
                          : isExpand[i]
                              ? ".... عرض أقل "
                              : "  .... عرض المزيد",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
              onTap: () {
                isExpand[i] = !isExpand[i];
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  downloadImg(i, String image) async {
    try {
      var postData = advertsbody[i];

      String id = postData["id"];

      int index = 0;

      for (int j = 0; j < postData["image"].length; j++) {
        if (postData["image"] == image) {
          index = j;
          break;
        }
      }
      String imageName = "X-POSITRON-Posts-" + id + "-" + index.toString();

      var imageId = await ImageDownloader.downloadImage(image,
          destination: AndroidDestinationType.custom(directory: "Download")
            ..subDirectory("X-POSITRON/$imageName.png"));
      if (imageId == null) {
        return;
      }

      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } catch (error) {
      print(error);
    }
  }

  intro() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;

    double responsiveFont = width < 330 ? 16 : 20;

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Image.asset(
            "images/Adverts1.png",
            height: height * .4,
          ),
          bodyWidget: Container(),
          footer: Container(
            width: width * .6,
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 400),
              animationDuration: Duration(milliseconds: 700),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: AutoSizeText("تصفح المنشورات",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsiveFont, color: Color(0xff909295))),
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Adverts2.png",
            height: height * .4,
          ),
          bodyWidget: Container(),
          footer: Container(
            width: width * .6,
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 400),
              animationDuration: Duration(milliseconds: 700),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: AutoSizeText("صنف المنشورات",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsiveFont, color: Color(0xff909295))),
            ),
          ),
        ),
      ],
      onDone: () async {
        Navigator.of(context).pop();
      },
      dotsFlex: 2,
      done: AutoSizeText("فهمت",
          style: TextStyle(
            fontSize: 15,
          )),
      dotsDecorator: DotsDecorator(size: Size.square(6)),
      showNextButton: true,
      next: AutoSizeText("التالي",
          style: TextStyle(
            fontSize: 15,
          )),
      animationDuration: 700,
      curve: Curves.easeOut,
    );
  }
}
