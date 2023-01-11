import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:x_positron/provider/ads.dart';

class AdBanner extends StatefulWidget {
  AdBanner({Key? key}) : super(key: key);

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late BannerAd bannerad;
  bool _isReady = false;
  bool _iserror = false;
  AdSize _adSize = AdSize.banner;
  void createBannerAd() {
    bannerad = BannerAd(
        size: _adSize,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isReady = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          _iserror = true;
          setState(() {});
        }),
        request: AdRequest());
    bannerad.load();
  }

  @override
  void initState() {
    createBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    bannerad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
    );
    // _isReady
    //     ? Container(
    //         width: _adSize.width.toDouble(),
    //         height: _adSize.height.toDouble(),
    //         alignment: Alignment.center,
    //         child: AdWidget(ad: bannerad),
    //       )
    //     : !_iserror
    //         ? Container(
    //             width: _adSize.width.toDouble(),
    //             height: _adSize.height.toDouble(),
    //             alignment: Alignment.center,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Atom(
    //                   size: _adSize.height.toDouble(),
    //                   nucleusRadiusFactor: 2,
    //                   orbitsColor: Colors.blue,
    //                   nucleusColor: Colors.blue,
    //                   electronsColor: Colors.blue,
    //                   orbit1Angle: (0),
    //                   orbit2Angle: (3.14 / 3),
    //                   orbit3Angle: (3.14 / -3),
    //                   animDuration1: Duration(milliseconds: 1000),
    //                   animDuration2: Duration(milliseconds: 1300),
    //                   animDuration3: Duration(milliseconds: 800),
    //                 ),
    //                 Text(
    //                   " ... جاري تحميل الاعلان ",
    //                   style: TextStyle(fontSize: 18),
    //                 ),
    //               ],
    //             ),
    //           )
    //         : Container(
    //             width: _adSize.width.toDouble(),
    //             height: _adSize.height.toDouble(),
    //             alignment: Alignment.center,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Atom(
    //                   size: _adSize.height.toDouble(),
    //                   nucleusRadiusFactor: 2,
    //                   orbitsColor: Colors.red,
    //                   nucleusColor: Colors.red,
    //                   electronsColor: Colors.red,
    //                   orbit1Angle: (0),
    //                   orbit2Angle: (3.14 / 3),
    //                   orbit3Angle: (3.14 / -3),
    //                   animDuration1: Duration(milliseconds: 1000),
    //                   animDuration2: Duration(milliseconds: 1300),
    //                   animDuration3: Duration(milliseconds: 800),
    //                 ),
    //                 Text(
    //                   " فشل تحميل الاعلان ",
    //                   style: TextStyle(fontSize: 18),
    //                 ),
    //               ],
    //             ),
    //           );
  }
}
