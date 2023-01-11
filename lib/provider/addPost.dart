import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'connectivity.dart';
import 'offline.dart';
import 'package:dio/dio.dart';

class AddPost extends StatefulWidget {
  final List postTypes;
  const AddPost({Key? key, required this.postTypes}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  PageController pagecontroller = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int imagePageCounter = 0;

  int _currentStep = 0;
  String inputText = "";
  String email = "";
  String type = "";

  static final String url =
      'https://xpositron.000webhostapp.com/flutter/upload_image.php';
  // "http://localhost/test/flutter/upload_image.php";
  List base64Image = [];
  List image = [];
  List imagePath = [];
  final imagePicker = ImagePicker();

  pickImg() async {
    List<XFile>? pickedImage;
    pickedImage = await imagePicker.pickMultiImage();
    bool isBigImage = false;
    if (pickedImage != null) {
      if (pickedImage.length <= 5) {
        for (int i = 0; i < pickedImage.length; i++) {
          if (await pickedImage[i].length() / 1024 / 1024 < 2) {
            imagePath.add(pickedImage[i].path);
          } else {
            isBigImage = true;
          }
        }
        if (isBigImage) {
          final snack = SnackBar(
            content: AutoSizeText(
              " يرجى أختيار صور حجمها أقل من 2 ميغا",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      } else {
        final snack = SnackBar(
          content: AutoSizeText(
            " يرجى أختيار خمسة صور أو أقل",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    }

    setState(() {});
  }

  double _received = 0;
  Widget errorwidget = AutoSizeText("يتم التحضير");
  String uploadStatus = "يتم التحضير";
  bool isdone = false;
  bool isError = false;
  Response? response;
  Dio dio = new Dio();
  List<String> fileName = ["", "", "", "", ""];
  uploadData() async {
    try {
      if (inputText != "" && type != "") {
        image.clear();
        fileName = ["", "", "", "", ""];
        base64Image.clear();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var id = prefs.getString("id") ?? Random().nextInt(1000).toString();
        var username = (prefs.getString("username") ?? "Unknown");
        for (int i = 0; i < imagePath.length; i++) {
          image.add(File(imagePath[i]).readAsBytesSync());

          base64Image.add(base64Encode(image[i]));

          fileName[i] = (id +
              "_${i}_" +
              Random().nextInt(1000).toString() +
              "_" +
              imagePath[i].split('/').last);
        }

        print(base64Image.length);
        FormData formdata = FormData.fromMap({
          "id": id,
          "text": inputText,
          "type": type,
          "username": username,
          "email": email,
          "img1": fileName[0],
          "img2": fileName[1],
          "img3": fileName[2],
          "img4": fileName[3],
          "img5": fileName[4],
        });

        response = await dio.post(
          url,
          data: formdata,
          options: Options(
            sendTimeout: 3600 * 1000,
            responseType: ResponseType.json,
            headers: {
              Headers.acceptHeader: "Application/json",
              Headers.contentLengthHeader: formdata.length,
              Headers.contentTypeHeader: "multipart/form-data",
            },
          ),
          onSendProgress: (int sent, int total) {
            setState(() {
              _received = (sent / total);
              if (_received > .4) {
                _received -= .09;
              }
              print("_received : " + _received.toString());
              uploadStatus = "يتم تحضير بيانات المنشور";
            });
          },
        );

        if (response?.statusCode == 200) {
          var responsebody = jsonDecode(response.toString());

          print(responsebody["url"]);

          if (imagePath.length > 0) {
            _received = 0;
            uploadImage(responsebody!["url"]);
          } else {
            isdone = true;
            setState(() {});
          }
        }
      } else {
        final snack = SnackBar(
          content: AutoSizeText(
            inputText == "" ? " يرجى كتابة المنشور" : "يرجى اختيار فئة المنشور",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    } catch (e) {
      print(e);
      isError = true;
      errorwidget = Column(
        children: [
          AutoSizeText("حدث خطأ ما يرجى اعادة المحاولة"),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.red,
              size: 50,
            ),
            onPressed: () {
              isError = false;
              uploadData();
            },
          )
        ],
      );
      setState(() {});
    }
  }

  uploadImage(uploadUrl) async {
    // String uri = "http://x-positron-store.atwebpages.com/putImage.php";
    // "https://xpositron.000webhostapp.com/flutter/putImage.php";

    try {
      final request = MultipartRequest(
        'POST',
        Uri.parse(uploadUrl),
        onProgress: (int bytes, int total) {
          _received = (bytes / total);
          if (_received < .95 && _received > .9) {
            _received -= .2;
          } else if (_received > .95) {
            _received -= .02;
          }

          print(_received);
          uploadStatus = "يتم رفع الصور";

          setState(() {});
        },
      );
      request.fields["length"] = "${imagePath.length}";
      for (int i = 0; i < imagePath.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('file$i', imagePath[i],
              filename: fileName[i]),
        );
      }

      final streamedResponse = await request.send().then((value) {
        setState(() {
          _received = 1;
          isdone = true;
        });
      });
    } catch (e) {
      isError = true;
      errorwidget = Column(
        children: [
          AutoSizeText("حدث خطأ ما يرجى اعادة المحاولة"),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.red,
              size: 50,
            ),
            onPressed: () {
              isError = false;
              uploadData();
            },
          )
        ],
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {}

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: AutoSizeText(
              "اضافة منشور",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 3,
            actions: []),
        body: Consumer<ConnectivityProvider>(builder: (context, online, child) {
          if (online.isOnline == false) {
            return Offline();
          }
          if (online.isOnline == true) {
            return _received == 0 ? steps() : downloading();
          }
          return Container();
        }));
  }

  downloading() {
    return ListView(
      children: [
        DelayedWidget(
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            animationDuration: Duration(milliseconds: 700),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    child: Image.asset("images/post.png")),
                !isdone
                    ? !isError
                        ? CircularPercentIndicator(
                            radius: 80,
                            lineWidth: 10,
                            curve: Curves.easeInOut,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.blue,
                            percent: _received,
                            center: AutoSizeText(
                                (_received * 100).floor().toStringAsFixed(0) +
                                    " %"),
                            footer: AutoSizeText(uploadStatus),
                          )
                        // when Error Occurs
                        : errorwidget
                    : DelayedWidget(
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        animationDuration: Duration(milliseconds: 700),
                        child: Column(
                          children: [
                            Icon(
                              Icons.done_rounded,
                              color: Colors.green.shade400,
                              size: 40,
                            ),
                            AutoSizeText(
                                "تم رفع المنشور و يتم الان مراجعته من قبل المسئولين"),
                          ],
                        )),
              ],
            )),
      ],
    );
  }

  steps() {
    return Stepper(
      steps: [
        Step(
            isActive: _currentStep >= 0,
            state: _currentStep == 0
                ? StepState.editing
                : _currentStep > 0
                    ? inputText == ""
                        ? StepState.error
                        : StepState.complete
                    : StepState.indexed,
            title: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: _currentStep > 0
                      ? inputText == ""
                          ? Colors.red
                          : Colors.blue
                      : Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  "كتابة المنشور",
                  style: TextStyle(
                    fontSize: 16,
                    color: _currentStep > 0
                        ? inputText == ""
                            ? Colors.red
                            : Colors.blue
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            content: stepOne()),
        Step(
          isActive: imagePath.length >= 1 || _currentStep >= 1,
          state: imagePath.length >= 1
              ? StepState.complete
              : _currentStep == 1
                  ? StepState.editing
                  : _currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
          title: Row(
            children: [
              Icon(
                Icons.add_a_photo_rounded,
                color: imagePath.length >= 1
                    ? Colors.blue
                    : _currentStep > 0
                        ? Colors.blue
                        : Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              AutoSizeText(
                "الصور",
                style: TextStyle(
                  fontSize: 16,
                  color: imagePath.length >= 1
                      ? Colors.blue
                      : _currentStep > 0
                          ? Colors.blue
                          : Colors.grey,
                ),
              ),
            ],
          ),
          content: stepTwo(),
        ),
        Step(
            isActive: type != "" || _currentStep == 2,
            state: _currentStep == 2
                ? StepState.editing
                : type != ""
                    ? StepState.complete
                    : _currentStep > 1
                        ? StepState.error
                        : StepState.indexed,
            title: Row(
              children: [
                Icon(
                  Icons.category_rounded,
                  color: type != "" || _currentStep == 2
                      ? Colors.blue
                      : _currentStep > 1
                          ? Colors.red
                          : Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                AutoSizeText("أختر الفئة",
                    style: TextStyle(
                      color: type != "" || _currentStep == 2
                          ? Colors.blue
                          : _currentStep > 1
                              ? Colors.red
                              : Colors.grey,
                    )),
              ],
            ),
            content: stepThree()),
        Step(
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            title: Row(
              children: [
                Icon(
                  Icons.email_rounded,
                  color: _currentStep == 3 ? Colors.blue : Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                AutoSizeText("رسالة تاكيد",
                    style: TextStyle(
                        color: _currentStep == 3 ? Colors.blue : Colors.grey)),
              ],
            ),
            content: stepFour()),
      ],
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep == 3) {
          _received = 1;
          setState(() {});
          uploadData();
        } else {
          _currentStep++;
        }
        setState(() {});
      },
      onStepCancel: () {
        _currentStep--;
        setState(() {});
      },
      onStepTapped: (step) {
        _currentStep = step;
        setState(() {});
      },
      controlsBuilder: (context, controls) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: controls.onStepContinue,
                      child: _currentStep != 3
                          ? AutoSizeText("التالي")
                          : AutoSizeText("نشر"))),
              SizedBox(
                width: 20,
              ),
              if (_currentStep != 0)
                Expanded(
                    child: ElevatedButton(
                        onPressed: controls.onStepCancel,
                        child: AutoSizeText("رجوع"))),
            ],
          ),
        );
      },
    );
  }

  stepOne() {
    return Container(
      height: 200,
      child: TextFormField(
        onChanged: (text) {
          inputText = text;
        },
        initialValue: inputText == "" ? null : inputText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.newline,
        minLines: null,
        maxLines: null,
        expands: true,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintText: "بماذا تفكر ؟",
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(color: Colors.black, fontSize: 14),
          contentPadding: EdgeInsets.all(20),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Colors.blue.shade300,
          )),
        ),
      ),
    );
  }

  stepTwo() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
          margin: EdgeInsets.all(20),
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight) *
              0.5,
          width: 200,
          decoration: BoxDecoration(
              color: imagePath.length == 0
                  ? Colors.grey.shade200
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: imagePath.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_rounded,
                      color: Colors.blue,
                      size: 80,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: AutoSizeText(
                        " يرجى عدم اختيار اكثر من خمسة صور"
                        " (اختياري) ",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              : imagePath.length == 1
                  ? Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  kToolbarHeight) *
                              0.35,
                          child: Image.file(
                            File(
                              imagePath[0],
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              imagePath.removeAt(0);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            )),
                      ],
                    )
                  : PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      reverse: true,
                      controller: pagecontroller,
                      scrollDirection: Axis.horizontal,
                      itemCount: imagePath.length,
                      onPageChanged: (index) {
                        imagePageCounter = index;
                      },
                      itemBuilder: (context, i) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Image.file(
                                File(imagePath[i]),
                                fit: BoxFit.cover,
                              ),
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_circle_left_rounded,
                                      color: Colors.blue,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      if (imagePageCounter ==
                                          imagePath.length - 1) {
                                        imagePageCounter = 0;
                                      } else {
                                        imagePageCounter++;
                                      }
                                      pagecontroller.animateToPage(
                                          imagePageCounter,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut);
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      imagePath.removeAt(i);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 35,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_circle_right_rounded,
                                      color: Colors.blue,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      if (imagePageCounter == 0) {
                                        imagePageCounter = imagePath.length - 1;
                                      } else {
                                        imagePageCounter--;
                                      }
                                      pagecontroller.animateToPage(
                                          imagePageCounter,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut);
                                    }),
                              ],
                            ),
                          ],
                        );
                      })),
      onTap: () {
        if (imagePath.length == 0) {
          pickImg();
        }
      },
    );
  }

  stepThree() {
    double width = MediaQuery.of(context).size.width;
    return DropdownButtonFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      alignment: Alignment.bottomRight,
      borderRadius: BorderRadius.circular(20),
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
          width: 2,
        )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
          width: 2,
        )),
      ),
      dropdownColor: Colors.grey.shade200,
      hint: Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(children: [
          Icon(
            Icons.touch_app_rounded,
            color: Colors.black,
            // size: width < 350 ? 25 : 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "أختر الفئة",
            style:
                TextStyle(color: Colors.black, fontSize: width < 350 ? 15 : 20),
          )
        ]),
      ),
      items: [
        ...List.generate(widget.postTypes.length, (i) {
          return DropdownMenuItem(
            child: Center(
              child: Text("${widget.postTypes[i]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            value: widget.postTypes[i],
          );
        })
      ],
      onChanged: (val) {
        type = val.toString();
        setState(() {});
      },
    );
  }

  regexp_email(String iv) {
    if (iv.length != 0) {
      if (!RegExp(
              r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
          .hasMatch(iv)) {
        return true;
      }
    }
    return false;
  }

  stepFour() {
    return Column(
      children: [
        AutoSizeText(
          "لتصلك رسالة تاكيد عن حالة المنشور",
          maxLines: 1,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          onChanged: (_email) {
            email = _email;
          },
          validator: (val) {
            if (regexp_email(val.toString())) {
              return "يرجى كتابة بريد الكتروني صالح";
            }
          },
          initialValue: email == "" ? null : email,
          maxLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintTextDirection: TextDirection.rtl,
            hintText: "أكتب بريد الكتروني صالح (اختياري)",
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
            contentPadding: EdgeInsets.all(10),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 2,
              color: email.length == 0
                  ? Colors.blue
                  : !regexp_email(email)
                      ? Colors.green
                      : Colors.blue.shade300,
            )),
          ),
        )
      ],
    );
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    required this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        if (total >= bytes) {
          sink.add(data);
        }
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
