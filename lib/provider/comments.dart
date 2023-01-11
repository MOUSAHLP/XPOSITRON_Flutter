import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_positron/provider/refresh.dart';
import 'package:http/http.dart' as http;
import 'package:x_positron/provider/skeleton.dart';
import 'connectivity.dart';
import 'offline.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class Comments extends StatefulWidget {
  final likes;
  final postId;

  const Comments({
    Key? key,
    this.likes,
    this.postId,
  }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  List commentData = [];
  List isExpanded = [];
  bool dataget = false;
  String userComment = "";
  TextEditingController _controller = TextEditingController();
  Future getComments() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/posts/getComments.php");

      var response = await http.post(url, body: {
        "postId": widget.postId,
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      commentData.clear();
      commentData.addAll(responsebody);
      isExpanded = List.filled(commentData.length, false);
      dataget = true;
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
              getComments();
            }).show();
      } catch (e) {}
    }

    setState(() {});
  }

  Future setComment(String comment) async {
    try {
      comment = comment.trim();
      if (comment != "") {
        final url = Uri.parse(
            "https://xpositron.000webhostapp.com/flutter/posts/setComment.php");

        final headers = <String, String>{"Accept": "Application/json"};

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var id = prefs.getString("id");
        var response = await http.post(url,
            body: {
              "postId": widget.postId,
              "userId": id,
              "comment": comment,
            },
            headers: headers);
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        if (responsebody["user_id"] != null) {
          commentData.insert(0, responsebody);
        }
      }
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  deleteComment(commentId) async {
    try {
      commentData.removeWhere((element) => element["id"] == commentId);
      final snack = SnackBar(
        content: Text(
          "تم حذف التعليق بنجاح",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/posts/deleteComment.php");

      var response = await http.post(
        url,
        body: {
          "postId": widget.postId,
          "commentId": commentId,
        },
      );
      var responsebody = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  var id;
  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString("id");
  }

  getTime(date) {
    date = DateTime.parse(date);
    var difference = DateTime.now().difference(date);
    if (difference.inSeconds < 10) {
      return "الان ";
    } else if (difference.inSeconds < 60) {
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

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      getComments();
    }
    getuserid();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime preBackpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, commentData.length);
        return true;
      },
      child: Scaffold(
          bottomSheet: inputComment(),
          appBar: AppBar(
              backgroundColor: Color(0xffe9f1fe),
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 3,
              actions: [
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white)),
                      child: Center(
                        child:
                            Icon(Icons.thumb_up, size: 12, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(widget.likes,
                        style: TextStyle(color: Colors.black)),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ]),
          body:
              Consumer<ConnectivityProvider>(builder: (context, online, child) {
            if (online.isOnline == false) {
              return RefreshWidget(
                  keyRefresh: keyRefresh,
                  onRefresh: getComments,
                  child: Offline());
            }
            if (online.isOnline == true) {
              return !dataget
                  ? RefreshWidget(
                      keyRefresh: keyRefresh,
                      onRefresh: getComments,
                      child: commentSkeleton(context))
                  : RefreshWidget(
                      keyRefresh: keyRefresh,
                      onRefresh: getComments,
                      child: commentData.length > 0
                          ? Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: commentData.length,
                                      itemBuilder: (context, i) {
                                        return comment(
                                          i,
                                          commentData[i]["id"],
                                          commentData[i]["username"],
                                          commentData[i]["user_id"],
                                          commentData[i]["comment"],
                                          commentData[i]["date"],
                                          commentData[i]["userImage"],
                                          commentData[i]["verified"],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            )
                          : Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.comments_disabled_rounded,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AutoSizeText(
                                    "كن أول من يعلق ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ));
            }
            return Container();
          })),
    );
  }

  Widget comment(i, commentId, name, userId, comment, date, image, verified) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          text: comment,
        ));
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 130);

    List boxes = textPainter.computeLineMetrics();

    return DelayedWidget(
      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
      animationDuration: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 110,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xffe9f1fe),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (id == userId)
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    deleteComment(commentId);
                                  }),
                            ),
                          ),
                        verified == "1"
                            ? Icon(
                                Icons.verified_rounded,
                                color: Colors.blue,
                              )
                            : Container(),
                        SizedBox(
                          width: 5,
                        ),
                        AutoSizeText(
                          name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: AutoSizeText(
                      getTime(date),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xff8a8d96),
                        fontSize: 8,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: double.infinity,
                      height: boxes.length <= 5
                          ? null
                          : isExpanded[i]
                              ? null
                              : 100,
                      child: Linkify(
                        textDirection: TextDirection.rtl,
                        text: comment,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xff5e6167),
                          fontSize: 14,
                        ),
                        linkStyle: TextStyle(color: Colors.blue),
                        onOpen: (link) async {
                          if (await canLaunchUrl(Uri.parse(link.url))) {
                            await launchUrl(Uri.parse(link.url));
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        AutoSizeText(
                            boxes.length <= 5
                                ? ""
                                : isExpanded[i]
                                    ? ".... عرض أقل "
                                    : "  .... عرض المزيد",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      isExpanded[i] = !isExpanded[i];
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            CircleAvatar(
                backgroundColor: Colors.white, child: cachedImage(image)),
          ],
        ),
      ),
    );
  }

  inputComment() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            onChanged: (text) {
              userComment = text;
            },
            toolbarOptions: ToolbarOptions(
                copy: true, cut: true, paste: true, selectAll: true),
            textDirection: TextDirection.rtl,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 1000,
            decoration: InputDecoration(
              hintText: "...تعليق",
              labelStyle: TextStyle(color: Colors.black, fontSize: 14),
              contentPadding: EdgeInsets.all(14),
              prefixIcon: Icon(
                Icons.comment,
                color: Colors.blue.shade300,
                size: 25,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                width: 2,
                color: Colors.blue.shade300,
              )),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setComment(userComment);
              setState(() {
                _controller.clear();
                userComment = "";
                FocusManager.instance.primaryFocus?.unfocus();
              });
            },
            icon: Icon(
              Icons.send,
              size: 30,
              color: Colors.blue.shade300,
            )),
      ],
    );
  }

  cachedImage(img) {
    return img != ""
        ? CachedNetworkImage(
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
          )
        : Icon(Icons.person);
  }
}
