import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class mainPageExplain extends StatelessWidget {
  final String text;
  final String title;
  const mainPageExplain({Key? key, required this.title, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AutoSizeText(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: [
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
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: width,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ])),
    );
  }
}
