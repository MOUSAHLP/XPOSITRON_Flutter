import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Offline extends StatelessWidget {
  const Offline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset("images/Offline.png", height: height * 0.6),
              ),
              AutoSizeText(
                "!! لا يوجد انترنت",
                maxLines: 1,
                style: TextStyle(
                    fontSize: width < 330 ? 25 : 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff909295)),
              ),
              SizedBox(
                height: 10,
              ),
              AutoSizeText(
                "يرجى التحقق من أتصالك بالأنترنت "
                "\n"
                "والمحاولة مجددا",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: width < 330 ? 17 : 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff909295)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
