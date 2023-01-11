import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_positron/animation/slider.dart';
import 'package:x_positron/provider/filesInFolders.dart';
import 'package:x_positron/provider/offline.dart';
import 'package:x_positron/provider/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:x_positron/provider/skeleton.dart';

class OnlineDownload extends StatefulWidget {
  final subject;
  final year;
  const OnlineDownload({Key? key, required this.subject, required this.year})
      : super(key: key);

  @override
  _OnlineDownloadState createState() => _OnlineDownloadState();
}

class _OnlineDownloadState extends State<OnlineDownload>
    with TickerProviderStateMixin {
  static List downloads = [];
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  static Map<String, Map<String, List>> filesFolders = {};
  static List foldersName = [];
  static List filesYear = [];
  static List files = [];

  onlineDownloads() async {
    try {
      final url = Uri.parse(
          "https://xpositron.000webhostapp.com/flutter/download_flutter.php");

      var response = await http.post(url, body: {
        "subject": "${widget.subject}",
        "year": "${widget.year}",
      });
      var responsebody = jsonDecode(response.body);

      downloads.clear();
      downloads.addAll(responsebody);

      // get filesYear
      downloads.forEach((element) {
        if (!filesYear.contains(element["year"])) {
          filesYear.add(element["year"]);
        }
      });

      // get folders names
      downloads.forEach((element) {
        if ((element["folder"] != null) &&
            (!foldersName.contains(element["folder"]))) {
          foldersName.add(element["folder"]);
        }
      });

      // for Folders files

      for (var year in filesYear) {
        Map<String, List> tmp = {};
        for (var folder in foldersName) {
          List tmpFileFolders = [];
          for (var file in downloads) {
            if (file["folder"] == folder && file["year"] == year) {
              tmpFileFolders.add(file);
            }
          }
          // print(tmpFileFolders.length);

          if (tmpFileFolders.isNotEmpty) {
            tmp[folder] = tmpFileFolders;
          }
        }
        filesFolders[year] = tmp;
      }

      // print(filesFolders["2022"]!["محاضرات"]?.length);

      // for UnFolder files
      for (var file in downloads) {
        if ((file["folder"] == null) && (!files.contains(file))) {
          files.add(file);
        }
      }

      setState(() {});
    } catch (e) {
      print(e);
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
              onlineDownloads();
            }).show();
      } catch (e) {}
    }
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

  @override
  void initState() {
    super.initState();
    var online = Provider.of<ConnectivityProvider>(context, listen: false);
    online.startMonitoring();
    if (online.isOnline == null || online.isOnline) {
      onlineDownloads();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        downloads.clear();
        filesFolders.clear();
        filesYear.clear();
        foldersName.clear();
        files.clear();

        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // bottomNavigationBar: AdBanner(),
          body:
              Consumer<ConnectivityProvider>(builder: (context, online, child) {
            if (online.isOnline == false) {
              return Offline();
            }
            if (online.isOnline == true) {
              return downloads.isEmpty
                  ? listViewSkeleton()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (foldersName.isNotEmpty)
                            ...List.generate(
                                filesYear.length,
                                ((index) =>
                                    folderGridWithTitle(filesYear[index]))),
                          if (files.isNotEmpty)
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(right: 20, top: 20),
                                child: AutoSizeText(
                                  "الملفات",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color(0xff5E6167),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          if (files.isNotEmpty) filsGrid()
                        ],
                      ),
                    );
            }

            return listViewSkeleton();
          })),
    );
  }

  filsGrid() {
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 1, mainAxisExtent: 200),
        itemCount: files.length,
        itemBuilder: (context, i) {
          Map _map;
          _map = files[i];
          String _filename = _map["fileName"];
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffe6f8fc),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  checkFileType(_filename),
                  Expanded(
                    child: Center(
                      child: AutoSizeText(
                        "${filename(_filename)}",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: width > 400 ? 23 : 18,
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
                      SizedBox(
                        height: 5,
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

  folderGridWithTitle(year) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20, top: 20, left: 20),
            child: AutoSizeText(
              year,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0xff5E6167),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
        folderGrid(year)
      ],
    );
  }

  folderGrid(year) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 130,
          crossAxisSpacing: 1,
        ),
        itemCount: filesFolders[year]!.length,
        itemBuilder: (context, i) {
          return InkWell(
            child: Container(
                child: Column(
              children: [
                Icon(
                  Icons.folder,
                  color: Colors.blue,
                  size: 70,
                ),
                AutoSizeText(
                  filesFolders[year]!.keys.toList()[i],
                  maxLines: 1,
                ),
                Text(
                  " تم التحديث " +
                      lastFoldersUpdate(
                          "${filesFolders[year]![filesFolders[year]!.keys.toList()[i]]![filesFolders[year]![filesFolders[year]!.keys.toList()[i]]!.length - 1]["date"]}"),
                  maxLines: 1,
                  style: TextStyle(color: Color(0xff909295), fontSize: 10),
                ),
                Text(
                    " "
                    " ${filesFolders[year]![filesFolders[year]!.keys.toList()[i]]!.length}"
                    " "
                    "ملف",
                    maxLines: 1,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Color(0xff909295), fontSize: 10)),
              ],
            )),
            onTap: () {
              Navigator.of(context).push(AnimateSlider(
                  Page: FilesInFolder(
                      files: filesFolders[year]![
                          filesFolders[year]!.keys.toList()[i]],
                      folderName: filesFolders[year]![
                          filesFolders[year]!.keys.toList()[i]]![0]["folder"]),
                  start: -1.0,
                  finish: 0.0));
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
}
