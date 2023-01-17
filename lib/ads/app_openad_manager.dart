import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {

  // String adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/3419835294'
  //     : 'ca-app-pub-3940256099942544/5662855259';
  String adUnitId = "";

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Load an AppOpenAd.
  void loadAd() {


    AppOpenAd.load(adUnitId: adUnitId, request: AdRequest(), adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
      print("load===true");

      _appOpenAd = ad;

    }, onAdFailedToLoad: (error) {


      print("error===$error");
    },), orientation: AppOpenAd.orientationPortrait);
  }


   void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
   }



/// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }
}
