class AdHelper {
  static const bool testMode = true;
  static String get bannerAdUnitId {
    if (testMode) {
      return "ca-app-pub-3940256099942544/6300978111";
    }
    return "ca-app-pub-7726114801279567/8982835897";
  }
}
