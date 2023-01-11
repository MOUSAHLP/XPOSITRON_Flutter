import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  final List imagesUrl;
  final int index;
  final PageController pageController;
  GalleryWidget({Key? key, required this.imagesUrl, this.index = 0})
      : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  List _progress = [];
  late int imageIndex = widget.index;
  @override
  void initState() {
    _progress = List.filled(widget.imagesUrl.length, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Column(
        children: [
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .1),
            child: PhotoViewGallery.builder(
                reverse: true,
                pageController: widget.pageController,
                itemCount: widget.imagesUrl.length,
                builder: (context, i) {
                  final imageUrl = widget.imagesUrl[i];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                  );
                },
                onPageChanged: (_index) {
                  setState(() {
                    this.imageIndex = _index;
                  });
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  " ${widget.imagesUrl.length} / ${imageIndex + 1} ",
                  style: TextStyle(color: Colors.white, height: 1.6),
                ),
                AutoSizeText(
                  "ملاحظة : سوف يتم تحميل الصورة في المسار التالي "
                  "\n"
                  "Download => X-POSITRON",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.white, fontSize: 12, height: 1.6),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      _progress[imageIndex].toString() + " %",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (_progress[imageIndex] == 100)
                      AutoSizeText(
                        "تم التحميل ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    if (_progress[imageIndex] == 100)
                      Icon(
                        Icons.done,
                        size: 22,
                        color: Colors.green,
                      )
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              downloadImg(imageIndex, widget.imagesUrl[imageIndex]);

              ImageDownloader.callback(onProgressUpdate: (imageId, progress) {
                setState(() {
                  _progress[imageIndex] = progress;
                  print(_progress[imageIndex]);
                });
              });
            },
            child: Center(
              child: AutoSizeText(
                "تحميل الصورة",
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  downloadImg(index, String image) async {
    try {
      var rand = Random().nextInt(1000);
      String imageName =
          "X-POSITRON-Posts-" + rand.toString() + "-" + index.toString();

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
}
