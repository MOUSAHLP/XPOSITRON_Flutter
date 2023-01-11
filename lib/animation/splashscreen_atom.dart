import 'package:auto_size_text/auto_size_text.dart';
import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';

class SplashscreenAtom extends StatefulWidget {
  const SplashscreenAtom({
    Key? key,
  }) : super(key: key);

  @override
  _SplashscreenAtomState createState() => _SplashscreenAtomState();
}

class _SplashscreenAtomState extends State<SplashscreenAtom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: size.height / 4),
        child: Column(
          children: [
            Atom(
              size: 200,
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
              height: 40,
            ),
            Container(
              child: AutoSizeText(
                "X-POSITRON",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                    fontFamily: "serif"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
