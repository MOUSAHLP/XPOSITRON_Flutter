import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesInFolder extends StatefulWidget {
  final files;
  final String folderName;
  FilesInFolder({Key? key, required this.files, required this.folderName})
      : super(key: key);

  @override
  State<FilesInFolder> createState() => _FilesInFolderState();
}

class _FilesInFolderState extends State<FilesInFolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: AutoSizeText(widget.folderName), elevation: 0),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Colors.blue,
              height: 50,
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  )),
            ),
            filsGrid()
          ]),
        ));
  }

  filsGrid() {
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 1, mainAxisExtent: 200),
        itemCount: widget.files.length,
        itemBuilder: (context, i) {
          Map _map;
          _map = widget.files[i];
          String _filename = _map["fileName"];
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffe6f8fc),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                children: [
                  checkFileType(_filename),
                  Expanded(
                    child: Center(
                      child: AutoSizeText(
                        "${filename(_filename)}",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: width > 400 ? 21 : 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AutoSizeText(
                            "(${double.parse((_map["fileSize"] / 1024 / 1024).toStringAsFixed(1))} MB)",
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff5e6167)),
                          ),
                          Container(
                              padding: EdgeInsets.only(right: 10),
                              width: 1,
                              height: 20,
                              color: Color(0xff909295)),
                          AutoSizeText(
                            "${_map["year"]}",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff5e6167)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AutoSizeText(
                        lastFoldersUpdate(_map["date"]),
                        maxLines: 1,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff5e6167)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () async {
              final url = "${_map["url"]}";
              if (await canLaunch(url)) {
                await launch(
                  url,
                  forceSafariVC: false,
                  forceWebView: false,
                  enableJavaScript: true,
                  enableDomStorage: true,
                );
              }
              setState(() {});
            },
          );
        });
  }

  lastFoldersUpdate(date) {
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

  checkFileType(String fileName) {
    double width = MediaQuery.of(context).size.width;
    if (fileName.contains(".zip")) {
      return Column(
        children: [
          FaIcon(
            FontAwesomeIcons.solidFileArchive,
            color: Colors.blue,
            size: width < 330 ? 30 : 40,
          ),
          Text("zip ملف",
              style: TextStyle(
                color: Colors.blue,
              ))
        ],
      );
    } else if (fileName.contains(".mp4")) {
      return Column(
        children: [
          FaIcon(
            FontAwesomeIcons.video,
            color: Colors.blue,
            size: width < 330 ? 30 : 40,
          ),
          Text(
            "mp4 ملف",
            style: TextStyle(
              color: Colors.blue,
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          FaIcon(
            FontAwesomeIcons.solidFilePdf,
            color: Colors.blue,
            size: width < 330 ? 30 : 40,
          ),
          Text(
            "pdf ملف",
            style: TextStyle(
              color: Colors.blue,
            ),
          )
        ],
      );
    }
  }

  filename(String _filename) {
    _filename = _filename.replaceFirst("\n", "");
    _filename = _filename.replaceFirst(".zip", "");
    _filename = _filename.replaceFirst(".mp4", "");
    _filename = _filename.replaceFirst(".pdf", "");
    return _filename.replaceFirst("(X-POSITRON)", "");
  }
}
