import 'package:flutter/material.dart';

class AnimateSlider extends PageRouteBuilder {
  final Page;
  final start;
  final finish;
  AnimateSlider({this.Page, this.start, this.finish})
      : super(
            pageBuilder: (context, animation, animationtwo) => Page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = Offset(start, finish);
              var end = Offset(0, 0);
              var tween = Tween(begin: begin, end: end);
              var curves =
                  CurvedAnimation(parent: animation, curve: Curves.linear);
              return SlideTransition(
                  position: tween.animate(curves), child: child);
            });
}

class AnimateScale extends PageRouteBuilder {
  final Page;

  AnimateScale({this.Page})
      : super(
            pageBuilder: (context, animation, animationtwo) => Page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var curves =
                  CurvedAnimation(parent: animation, curve: Curves.linear);
              return ScaleTransition(
                  scale: tween.animate(curves), child: child);
            });
}

// class AnimateRotate extends PageRouteBuilder {
//   final Page;
//   final start;
//   final finish;
//   AnimateRotate({this.Page, this.start, this.finish})
//       : super(
//             pageBuilder: (context, animation, animationtwo) => Page,
//             transitionsBuilder: (context, animation, animationtwo, child) {
//               var begin = start;
//               var end = finish;
//               var tween = Tween(begin: begin, end: end);
//               var curves =
//                   CurvedAnimation(parent: animation, curve: Curves.linear);
//               return RotationTransition(
//                   turns:tween.animate(curves), child: child);
//             });
// }
