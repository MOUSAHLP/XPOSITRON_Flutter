import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:create_atom/create_atom.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/mainpages/adverts.dart';
import 'package:x_positron/mainpages/contactus.dart';
import 'package:x_positron/mainpages/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x_positron/mainpages/questions.dart';
import 'package:x_positron/mainpages/subjects.dart';
import 'package:x_positron/mainpages/subjects_rate.dart';
import 'package:x_positron/mainpages/user_subjects.dart';
import 'package:x_positron/provider/introduction_dialog.dart';
import 'package:x_positron/provider/local_notification.dart';
import 'package:x_positron/provider/mainPageExplain.dart';
import 'package:x_positron/provider/subjects_info.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = " ";

  List containertap = List.filled(100, false);
  List<double> angle = List.filled(100, 0.0);

  List<Map> subjectList = [];
  List<Map> lastVisitedSubject = [];
  List<Map> homedata = [
    {
      "title": "ما هو X-POSITRON",
      "image": "images/positron2.png",
      "desc": " بيشرح كل مادة من مواد قسم هندسة الاتصالات و الألكترون للخمس سنين كلها ومنرفع روابط لتحميل المحاضرات ، ملحقات ، الكتب ، الدورات كلها محدثة لاخر اصدار مشان نساعدكم بالدراسة ونسهل عليكم مشواركم وتكون احلى خمس سنين بحياتكون ويعم السلام والسعادة و الأفراح بالكون "
          "\n_ و انشاء الله ما منقصر عليكم بشي واذا في سؤال أو انتقاد أو اي شي بدكون تتواصلوا معنا مشانو في قسم للتواصل معنا"
    },
    {
      "title": "لمحة عن الجامعة",
      "image": "images/university.png",
      "desc":
          "حقبة جديدة ومرحلة جديدة بحياتكم وحلوة بإذن الله متل ما بتعرفو صرتو جامعة وخايفين وصار في مسؤولية جديدة عليكم ومدري شو بس انتو قدا،هلأ الحياة الجامعية متل ما بيقولو من احلى فترات الحياة الي بعمركم ما رح تنسوها بس بدها تعب وجهد وطبعا سهر ليالي كتير بس اخر شي بتذوقو لذة النجاح انشالله،نحنا بالجامعة عنا كل المواد بتنقسم نظري و عملي العملي تقريبا بكون بين ال 20 و 30 علامة من 100 و الباقي نظري ولحتى تنجح بالمادة لازم يكون مجموع النظري والعملي فوق ال 60 ولح نشرح شلون بكون العملي بكل مادة .",
    },
    {
      "title": "نبذة عن القسم",
      "image": "images/college.png",
      "desc": "هندسة الإلكترونيات والاتصالات"
          "\n\n"
          "تُتْبَعُ هندسة الاتصالات أو الإلكترون والاتصالات بنحو عام إلى الهندسة الكهربائية، ويُعنى هذا الاختصاص بدراسة طيف واسع من المفهومات النظرية والتطبيقات العملية. مدة الدراسة في الجامعات الحكومية السورية كباقي الهندسات 5 سنوات على الأقل..."
          "\n\n"
          "• ما أهمية هندسة الإلكترون والاتصالات؟"
          "\n\n"
          "انظر حولك في المنزل، كل جهاز تستخدمه تقريبًا من التلفزيون إلى سخان الميكروويف إلى الهاتف النقال إلى الحاسوب إلى الكاميرا الرقمية إلى الراوتر إلى المكيف إلى الإنفرتر الذي يسهل حياتك حين ينقطع التيار الكهربائي، يعتمد على الإلكترونيات."
          "\n\n"
          "أكثر من ذلك، يأمِّن مهندسو الاتصالات تواصلك مع العالم؛ إذ يضعون التصاميم والخطط التنفيذية لشبكات الاتصالات الأرضية والخليوية والفضائية، التي تنقل البيانات الصوتية أو بيانات الوسائط المتعددة التي تتيح لك متابعة المسلسلات على التلفاز ومشاهدة فيديو على اليوتيوب والاتصال بأقربائك وأصدقائك على سكايب مثلًا، وفي قراءة هذا المقال أيضًا، وبسبب ارتباطها بتواصل المجتمع البشري ورفاهيته تعد هذه الهندسة من أكثر المجالات سرعة في النمو الاقتصادي والأكاديمي حول العالم."
          "\n\n"
          "• ما هي المجالات التي تُدرَّس في هندسة الإلكترون والاتصالات؟"
          "\n\n"
          "يمكن -في رأيي المتواضع- أن نُطلِق على هندسة الإلكترون والاتصالات لقب الهندسة الفضفاضة، فالدراسة لهذا الاختصاص تتضمن مجالًا واسعًا للغاية من التخصصات الفرعية، ولا بُدَّ أن ننوه بأن التفاصيل الآتية مأخوذة من المنهاج الخاص في جامعة دمشق لكن معظم الجامعات السورية الأخرى تنحو المنحى نفسه في طريقة توزيع المواد. "
          "\n\n"
          "	يبدأ الدارسون السنتين الأولَيَيْن بدراسة العلوم الأساسية من فيزياء ورياضيات ورسم هندسي، يقضي الدارسون -أيضًا- في هاتين السنتين وقتًا في دراسة مواد مكملة (كيمياء، عربي، قومية، إنكليزي ...)، إضافة إلى أساسيات القوانين الكهربائية والدارات الكهربائية وأسس الإلكترونيات. يُركَّز أكثر في خلال السنتين التي تليهما على الدارات الإلكترونية وعلم أنصاف النواقل والدارات المتكاملة والدارات المنطقية والمعالجات والخوارزميات وبنى المعطيات والتطرق إلى البرمجة الحاسوبية وأساسيات هندسة الاتصالات ومعالجة الإشارة التماثلية والرقمية والتحكم."
          "\n\n"
          " وفي السنة الأخيرة تركز المناهج على تقنيات الاتصالات الحديثة في مجال الاتصالات الفضائية والاتصالات الخليوية ونظرية المعلومات والتلفزة والشبكات الحاسوبية."
          "\n\n"
          " تتألف معظم المواد من قسم نظري يحظى غالبًا بـ 70 بالمئة من العلامة، وقسم عملي تخصص له غالبًا 30 بالمئة من العلامة. تُعطى علامة القسم النظري حسب الأداء في الامتحان، والقسم العملي تعتمد علاماته على الحضور والمذاكرات والوظائف والمخابر وحلقات البحث (ليس كل ما سبق، بل بعضه، بحسب المادة)"
          "\n\n"
          "• ما الصعوبات الأساسية في الدراسة؟"
          "\n\n"
          "ليست جميع المواد سهلة الفهم، الدوام طويل نسبيًّا، فترة الدراسة (5 سنوات) ليست قصيرة، وفيها في عديد من الأماكن الحشو الذي يشعر الطالب معه بأنه يهدر وقتًا على أشياء لا تفيده."
          "\n\n"
          "تتطلب دراسة الهندسة بنحو عام تركيبة مرنة للدماغ وقدرة على تحليل المشكلات وهامشًا من الإبداع والابتكار لتوفير الحلول لهذه المشكلات، وبسبب الأنظمة التعليمية الجامعية في بلدنا التي تعاني من ضعف التطور، فإن أثر هذه الميزة ضعيف أيضًا، والاتجاه السائد هو نحو الحفظ ودراسة المواد بهدف النجاح بها فقط، إضافة إلى أن ضعف التشجيع وإعداد المناهج لكثير من المواد يزيد أهمية قضية الاعتماد على الذات، ففي عالم الإنترنت لا يوجد حدود للمعلومات ولا شيء يستطيع منع الطالب من التعلم إذا رغب بذلك."
          "\n\n"
          "• ما المهارات التي يكتسبها الطالب في الجامعة؟"
          "\n\n"
          "يظن كثير من الطلاب أن تخرجهم من الجامعة يوفر لهم المعرفة، والحقيقة أن ما تقوم به الكلية لا يتعدى فك أمية الطالب في مجال الهندسة، فهي توفر لك اطلاعًا أوليًّا على المواد المدروسة، وعليك أنت أن تُنمي معارفك في المجال الذي تراه مناسبًا لتوجهاتك، سواءً كان ذلك خلال فترة دراستك (عن طريق توجهاتك وهواياتك) أم بعد التخرج (عن طريق العمل الذي تُقبل فيه)."
          "\n\n"
          "• ما هي فرص العمل بعد التخرج؟"
          "\n\n"
          "كما ذكرنا سابقًا تُعطيك هندسة الاتصالات أفضلية في العمل على مستويين، أولًا المجال الواسع من التخصصات التي تغطيها، وثانيًا النمو الاقتصادي الكبير والمتسارع الذي يشهده عالم التكنولوجيا.."
    }
  ];

  List<Map> mainPages = [
    {
      "name": "تقييماتي",
      "desc": "شاهد المواد التي قمت بتقييمها",
      "icon": Icon(Icons.favorite, color: Colors.red, size: 80),
      "navigate": User_subjects(),
    },
    {
      "name": "تقييمات المواد",
      "desc": "شاهد المواد الأكثر تقييما",
      "icon": FaIcon(FontAwesomeIcons.chartLine, color: Colors.blue, size: 80),
      "navigate": SubjectsRate(),
    },
    {
      "name": "تواصل معنا",
      "desc": "للاستفسار عن اي سؤال",
      "icon": Icon(Icons.feedback_rounded, color: Colors.blue, size: 80),
      "navigate": ContactUs(),
    },
    {
      "name": "الأسئلة الشائعة",
      "desc": "اسئلة وأجوبة عن الحياة الجامعية",
      "icon": Icon(Icons.question_answer_rounded, color: Colors.blue, size: 80),
      "navigate": Questions(),
    },
    {
      "name": "الاعلانات",
      "desc": "لمشاهدة و نشر المناشير",
      "icon": Icon(Icons.ad_units, color: Colors.blue, size: 80),
      "navigate": Adverts(),
    },
  ];

  var xpositronHeight = 0.0;
  late AnimationController controller1;
  late Animation animation1;
  late AnimationController controller2;
  late Animation animation2;

  randomSubjects() async {
    subjectList.clear();
    var subjects = await Provider.of<SubjectsInfo>(context, listen: false);
    var firstSubjects = subjects.firstYear;
    var secondSubjects = subjects.secondyear;
    var thirdSubjects = subjects.thirdyear;
    var forthSubjects = subjects.forthyear;
    var fifthSubjects = subjects.fifthyear;

    checkYearExist(year) {
      switch (year) {
        case 3:
          return thirdSubjects.isNotEmpty ? false : true;
        case 4:
          return forthSubjects.isNotEmpty ? false : true;
        case 5:
          return fifthSubjects.isNotEmpty ? false : true;
        default:
          return false;
      }
    }

    List<int> randoms = List.filled(5, 0);

    for (int i = 0; i < 5; i++) {
      Random rnd = Random();
      int randNum = rnd.nextInt(5) + 1;
      if (checkYearExist(randNum)) {
        i--;
        continue;
      }
      randoms[i] = randNum;
    }

    randoms.forEach((randomele) {
      List currentYearList = [];
      Random rnd = Random();
      int randNum = 0;

      if (randomele == 1) {
        currentYearList = firstSubjects;
      }
      if (randomele == 2) {
        currentYearList = secondSubjects;
      }
      if (randomele == 3) {
        currentYearList = thirdSubjects;
      }
      if (randomele == 4) {
        currentYearList = forthSubjects;
      }
      if (randomele == 5) {
        currentYearList = fifthSubjects;
      }
      bool h = false;

      while (h == false) {
        randNum = rnd.nextInt(currentYearList.length);

        h = true;
        subjectList.forEach((element) {
          if (element == currentYearList[randNum]) {
            h = false;
          }
        });
      }
      subjectList.add(currentYearList[randNum]);
    });
  }

  lastVisitedSubjectFun() async {
    var lastSubject =
        await Provider.of<SubjectsInfo>(context, listen: false).getVisited();

    var subjects = Provider.of<SubjectsInfo>(context, listen: false);

    var firstSubjects = subjects.firstYear;
    var secondSubjects = subjects.secondyear;
    var thirdSubjects = subjects.thirdyear;
    var forthSubjects = subjects.forthyear;
    var fifthSubjects = subjects.fifthyear;
    lastVisitedSubject.clear();

    for (int i = 0; i < lastSubject.length; i++) {
      if (lastSubject[i]["year"] == "1") {
        var task = firstSubjects.firstWhere(
            (element) => element["subjectName"] == lastSubject[i]["name"]);

        lastVisitedSubject.add(task);
      }
      if (lastSubject[i]["year"] == "2") {
        var task = secondSubjects.firstWhere(
            (element) => element["subjectName"] == lastSubject[i]["name"]);

        lastVisitedSubject.add(task);
      }
      if (lastSubject[i]["year"] == "3") {
        var task = thirdSubjects.firstWhere(
            (element) => element["subjectName"] == lastSubject[i]["name"]);

        lastVisitedSubject.add(task);
      }
      if (lastSubject[i]["year"] == "4") {
        var task = forthSubjects.firstWhere(
            (element) => element["subjectName"] == lastSubject[i]["name"]);

        lastVisitedSubject.add(task);
      }
      if (lastSubject[i]["year"] == "5") {
        var task = fifthSubjects.firstWhere(
            (element) => element["subjectName"] == lastSubject[i]["name"]);

        lastVisitedSubject.add(task);
      }
    }

    setState(() {});
  }

  Map updateList = {};
  double updateScale = 1.0;
  double updateArrowLeft = -114;
  late AnimationController controllerUpdate;
  late Animation animationUpdate;

  update() async {
    var version = Provider.of<SubjectsInfo>(context, listen: false).version;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await prefs.getString("update") != null) {
      var uptade = await jsonDecode(prefs.getString("update")!);

      updateList.clear();
      print(version);
      print(uptade["version"]);
      if (version != uptade["version"]) {
        updateList["title"] = uptade["title"];
        updateList["desc"] = uptade["desc"];
        updateList["link"] = uptade["link"];
      }
    }
    Future.delayed(Duration(seconds: 5), (() {
      setState(() {
        updateArrowLeft = 100;

        controllerUpdate = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1000),
        );

        animationUpdate = Tween(
          begin: 1.0,
          end: 0.0,
        ).animate(controllerUpdate)
          ..addListener(() {
            setState(() {
              updateScale = animationUpdate.value;
            });
          });
        controllerUpdate.forward();
      });
    }));
  }
//////////////////////////// for fcm messaging /////////////////////////

  void sendPushMessage() async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=BI8FS9SEKlPzCYgudr9QlJjDwZjuvVrT5nqtj5gihON5Y7Mf6uuBPD2Ck9BRhy6fB8nEuGNpCBgQavOzmZugPN0',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Test Body',
              'title': 'Test Title 2'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$token",
          },
        ),
      );
    } catch (e) {}
  }

  Future insertToken(token) async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/insertToken.php");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = await prefs.getString("id");

      var response = await http.post(url, body: {
        "id": id,
        "token": "$token",
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody["response"] == "inserted") {
        prefs.setString("token", "done");
      }
    } catch (e) {}
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((_token) {
      token = _token;
      print(token);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isInserted = await prefs.getString("token");
    if (isInserted != "done") {
      insertToken(token);
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.subscribeToTopic("xpositron");

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  Future<String> _base64encodedImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      Map<String, dynamic> messageData = message.data;
      // print(messageData);

      //   AndroidNotification? android = message.notification?.android;
      if (notification != null && !kIsWeb) {
        //     flutterLocalNotificationsPlugin.show(
        //       notification.hashCode,
        //       notification.title,
        //       notification.body,
        //       NotificationDetails(
        //         android: AndroidNotificationDetails(channel.id, channel.name,
        //             // TODO add a proper drawable resource to android, for now using
        //             //      one that already exists in example app.
        //             icon: '@mipmap/launcher_icon',
        //             importance: Importance.high,
        //             priority: Priority.high,
        //             color: Colors.blue),
        //       ),
        //     );
        if (messageData["image"] != "") {
          sendNotification(
              id: int.parse(messageData["id"]),
              title: notification.title,
              body: notification.body,
              image: messageData["image"]);
        } else {
          noImageNotification(
            id: int.parse(messageData["id"]),
            title: notification.title,
            body: notification.body,
          );
        }
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'X-POSITRON Notification', // id
        'X-POSITRON Notification ', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  void initState() {
    if (subjectList.isEmpty) {
      randomSubjects();
    }

    lastVisitedSubjectFun();
    Change(0);
    checkIntro();
    update();

    //firebase

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    // sendNotification(
    //     title: "تم قبول منشورك",
    //     body: " تم أضافة منشورك بنجاح<br> وشكرا لاستخدامك <br>X-POSITRON",
    //     image: "https://xpositronstore.000webhostapp.com/images/coding1.png");

    super.initState();
  }

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
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
            appBar: AppBar(
              title: AutoSizeText(
                "الصفحة الرئيسية",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                updateList.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          try {
                            AwesomeDialog(
                              context: context,
                              body: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      child: AutoSizeText(
                                          "${updateList["title"]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: Text("${updateList["desc"]}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 20))),
                                ],
                              ),
                              btnOkText: "تحديث الان",
                              btnOkOnPress: () async {
                                final url = updateList["link"];
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                  );
                                }
                              },
                            ).show();
                          } catch (e) {}
                        },
                        icon: Icon(Icons.warning_rounded,
                            color: Colors.red.shade600, size: 35))
                    : Container(),
                updateList.isNotEmpty
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            child: Text(""),
                          ),
                          AnimatedPositioned(
                              duration: Duration(milliseconds: 1000),
                              left: updateArrowLeft,
                              top: -35,
                              child: Transform.scale(
                                scale: updateScale,
                                child: Transform.rotate(
                                  angle: -3.14 / 2,
                                  child: Icon(Icons.arrow_drop_down,
                                      size: 130,
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              )),
                          Positioned(
                              left: -160,
                              child: Transform.scale(
                                scale: updateScale,
                                child: Container(
                                  width: 100,
                                  height: 70,
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text("تحديث جديد \n !!متوفر",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ))
                        ],
                      )
                    : Container(),
                IconButton(
                    onPressed: () {
                      showdialog(context, "الصفحة الرئيسية", intro());
                    },
                    icon: FaIcon(FontAwesomeIcons.questionCircle))
              ],
            ),
            drawer: Mydrawer(),
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width * .7,
                            child: AutoSizeText(
                              "X-POSITRON",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.yellow[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: width * .9,
                            child: AutoSizeText(
                              "المرجع الأول لقسم هندسة الألكترون والأتصالات",
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 30,
                                  color: Colors.blue[200]),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: AutoSizeText(
                        "تعرف على ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(2),
                      height: 210,
                      width: width,
                      child: ListView.builder(
                          reverse: true,
                          itemCount: homedata.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return InkWell(
                              child: Container(
                                width: 140,
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xffe6f8fc),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Transform.scale(
                                        scale: 1.2,
                                        child: Image.asset(
                                          homedata[i]["image"],
                                          // height: 140,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        AutoSizeText(
                                          homedata[i]["title"],
                                          textDirection: TextDirection.rtl,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(AnimateSlider(
                                    Page: mainPageExplain(
                                        title: homedata[i]["title"],
                                        text: homedata[i]["desc"]),
                                    start: -1.0,
                                    finish: 0.0));
                              },
                            );
                          }),
                    ),
                    Container(
                      padding: lastVisitedSubject.length != 0
                          ? EdgeInsets.fromLTRB(2, 4, 2, 20)
                          : EdgeInsets.fromLTRB(2, 4, 2, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: width * .6,
                                  child: AutoSizeText(
                                    "X-POSITRON بعض المواد في ",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    randomSubjects();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.refresh_rounded,
                                      size: width < 330 ? 30 : 35)),
                            ],
                          ),
                          Container(
                              width: double.infinity,
                              height: 210,
                              child: subjectListView(subjectList)),
                          lastVisitedSubject.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Text(""),
                          lastVisitedSubject.length != 0
                              ? Container(
                                  child: Text(
                                  "اخر المواد التي زرتها",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                              : Text(""),
                          lastVisitedSubject.length != 0
                              ? Container(
                                  width: double.infinity,
                                  height: 210,
                                  child: subjectListView(lastVisitedSubject))
                              : Text(""),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        AutoSizeText(
                          "الصفحات الرئيسية",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 210,
                          width: width,
                          child: mainPagesGridView(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget subjectListView(List<Map> map) {
    return Container(
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: map.length,
          itemBuilder: (context, i) {
            return DelayedWidget(
              delayDuration: Duration(milliseconds: 200),
              animationDuration: Duration(milliseconds: 500),
              animation: DelayedAnimations.SLIDE_FROM_LEFT,
              child: Container(
                width: 140,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffe6f8fc),
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      map[map.length - 1 - i]["image"] != null
                          ? CachedNetworkImage(
                              imageUrl: map[map.length - 1 - i]["image"],
                              height: 80,
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
                          : Container(),
                      AutoSizeText(
                        "${map[map.length - 1 - i]["arabicName"]}",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff5E6167),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        " ${whichYear(map[map.length - 1 - i]["year"])}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(AnimateSlider(
                            Page: Subjects(
                              subject: map[map.length - 1 - i]["subjectName"],
                              arabSubject: map[map.length - 1 - i]
                                  ["arabicName"],
                              year: map[map.length - 1 - i]["year"],
                              sumester: map[map.length - 1 - i]["sumester"],
                              isauto: map[map.length - 1 - i]["isauto"],
                              iswork: map[map.length - 1 - i]["iswork"],
                              explain: map[map.length - 1 - i]
                                  ["subjectExplain"],
                            ),
                            start: -1.0,
                            finish: 0.0))
                        .then((value) => lastVisitedSubjectFun());
                  },
                ),
              ),
            );
          }),
    );
  }

  whichYear(year) {
    switch (year) {
      case "1":
        return 'السنة الأولى';
      case "2":
        return 'السنة الثانية';
      case "3":
        return 'السنة الثالثة';
      case "4":
        return 'السنة الرابعة';
      case "5":
        return 'السنة الخامسة';
    }
  }

  mainPagesGridView() {
    return ListView.builder(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: mainPages.length,
        itemBuilder: (context, i) {
          return InkWell(
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 200),
              animationDuration: Duration(milliseconds: 500),
              animation: DelayedAnimations.SLIDE_FROM_LEFT,
              child: Container(
                width: 140,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffe6f8fc),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Column(
                  children: [
                    mainPages[i]["icon"],
                    AutoSizeText("${mainPages[i]["name"]}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff023047),
                          fontWeight: FontWeight.bold,
                        )),
                    AutoSizeText("${mainPages[i]["desc"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(AnimateSlider(
                  Page: mainPages[i]["navigate"], start: -1.0, finish: 0.0));
            },
          );
        });
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
            "images/hello.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(
                      "X-POSITRON اهلا بك في"
                      "\n",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(
                      "المرجع الأول في قسم هندسة الأتصالات والألكترون",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                )
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Home_Page1.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(
                      " : تعرف على "
                      "\n",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText("X-POSITRON ما هو _",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 800),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText("لمحة عن الجامعة _",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 900),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText("نبذة عن القسم _",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Home_Page2.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Column(
                    children: [
                      AutoSizeText("ستجد مواد عشوائية من كل السنين ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: responsiveFont,
                              color: Color(0xff909295))),
                      AutoSizeText(
                          " الموجودة في "
                          "X-POSITRON",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: responsiveFont,
                              color: Color(0xff909295))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 700),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(" ستجد اخر المواد التي كنت قد زرتها ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Image.asset(
            "images/Home_Page3.png",
            height: height * .4,
          ),
          bodyWidget: Container(
            width: width * .6,
            child: Column(
              children: [
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: AutoSizeText(
                      " : تنقل سريعا الى "
                      "\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsiveFont, color: Color(0xff909295))),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 900),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText(" المواد الأكثر تقييما _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1100),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText("تقييماتي  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1300),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText("الأسئلة الشائعة  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 1500),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText("قسم التواصل معنا  _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
                DelayedWidget(
                  delayDuration: Duration(milliseconds: 900),
                  animationDuration: Duration(milliseconds: 700),
                  animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                  child: Container(
                    width: double.infinity,
                    child: AutoSizeText(" الاعلانات _",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: responsiveFont,
                            color: Color(0xff909295))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("homeIntro", true);
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

  checkIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getBool("homeIntro") ?? false;
    if (check == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showdialog(context, "الصفحة الرئيسية", intro());
      });
    }
  }
}
