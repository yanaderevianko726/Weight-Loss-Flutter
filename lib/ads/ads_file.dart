import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../iapurchase/prefrence.dart';
import 'ads_info.dart';

AdRequest request = const AdRequest(
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  nonPersonalizedAds: true,
);

class AdsFile {
  BuildContext? context;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  Widget? faceBookBanner;
  bool isInterstitialAdLoaded = false;

  AdsFile(BuildContext c) {
    context = c;
  }

  void disposeRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.dispose();
    }
  }

  BannerAd? _anchoredBanner;

  void showRewardedAd(Function function, Function function1) async {
    bool _isRewarded = false;
    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();

        if (_isRewarded) {
          function();
        } else {
          function1();
        }
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();

        createRewardedAd();
      },
    );

    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      _isRewarded = true;
    });
    _rewardedAd = null;
  }

  Future<bool> checkInApp() async {
    bool isPurchase = await Preferences.preferences
        .getBool(key: PrefernceKey.isProUser, defValue: false);

    return isPurchase;
  }

  Future<void> createRewardedAd() async {
    bool i = await checkInApp();
    if (!i) {
      RewardedAd.load(
          adUnitId: getRewardBasedVideoAdUnitId(),
          request: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              _rewardedAd = null;
              createRewardedAd();
            },
          ));
    }
  }

  void disposeInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
    }

    // FacebookInterstitialAd.destroyInterstitialAd();
  }

  void showInterstitialAd(Function function, var setState) {
    // if (_interstitialAd == null) {
    //   function();
    //
    //   return;
    // }
    // _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //   onAdShowedFullScreenContent: (InterstitialAd ad) {},
    //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //     ad.dispose();
    //     function();
    //   },
    //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    //     ad.dispose();
    //     createInterstitialAd();
    //   },
    // );
    // _interstitialAd!.show();
    // _interstitialAd = null;
    if (isInterstitialAdLoaded == false) {
      function();
      return;
    }
    // if (isInterstitialAdLoaded == true) {
    FacebookInterstitialAd.showInterstitialAd();
    //   setState(() {
    //     isInterstitialAdLoaded = false;
    //   });
    // } else {
    //   function();
    // }
  }

  Future<void> createInterstitialAd(var setState, Function function) async {
    // bool i = await checkInApp();
    // if (!i) {
    //   InterstitialAd.load(
    //       adUnitId: getInterstitialAdUnitId(),
    //       request: request,
    //       adLoadCallback: InterstitialAdLoadCallback(
    //         onAdLoaded: (InterstitialAd ad) {
    //           _interstitialAd = ad;
    //         },
    //         onAdFailedToLoad: (LoadAdError error) {
    //           _interstitialAd = null;
    //           createInterstitialAd();
    //         },
    //       ));
    // }
    bool i = await checkInApp();

    if (!i) {
      FacebookInterstitialAd.loadInterstitialAd(
        placementId: getInterstitialAdUnitId(),
        listener: (result, value) {
          print("inteads---------------${result}----------------${value}");
          if (result == InterstitialAdResult.LOADED) {
            // setState(() {
            isInterstitialAdLoaded = true;
            // });
          } else if (result == InterstitialAdResult.DISMISSED) {
            print("dismiss-----------true");
            // setState(() {
            isInterstitialAdLoaded = false;
            // });
            createInterstitialAd(setState, function);
            function();
          } else if (result == InterstitialAdResult.ERROR) {
            createInterstitialAd(setState, function);
          }
        },
      );
    }
  }

  createAnchoredBanner(BuildContext context, var setState,
      {Function? function}) async {
    bool i = await checkInApp();
    if (!i) {
      // final AnchoredAdaptiveBannerAdSize? size =
      //     await AdSize.getAnchoredAdaptiveBannerAdSize(
      //   Orientation.portrait,
      //   MediaQuery.of(context).size.width.truncate(),
      // );
      //
      // if (size == null) {
      //   return;
      // }
      //
      // final BannerAd banner = BannerAd(
      //   size: size,
      //   request: request,
      //   adUnitId: getBannerAdUnitId(),
      //   listener: BannerAdListener(
      //     onAdLoaded: (Ad ad) {
      //       setState(() {
      //         _anchoredBanner = ad as BannerAd?;
      //       });
      //       if (function != null) {
      //         function();
      //       }
      //     },
      //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
      //       ad.dispose();
      //     },
      //     onAdOpened: (Ad ad) => {},
      //     onAdClosed: (Ad ad) => {},
      //   ),
      // );
      // banner.load();
    }
  }

  void disposeBannerAd() {
    if (_anchoredBanner != null) {
      _anchoredBanner!.dispose();
    }
  }

  Future<Widget> createFacebookBanner() async {
    Widget _currentAd = SizedBox(
      width: 0.0,
      height: 0.0,
    );
    bool i = await checkInApp();
    if (!i) {
      _currentAd = FacebookBannerAd(
        placementId: getBannerAdUnitId(),
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              print("Error===: $value");
              break;
            case BannerAdResult.LOADED:
              print("Loaded===: $value");
              break;
            case BannerAdResult.CLICKED:
              print("Clicked===: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              print("Logging Impression===: $value");
              break;
          }
        },
      );
    }
    return _currentAd;
  }

  getFacebookBanner(
    var setState,
  ) {
    createFacebookBanner().then(
      (value) {
        print("banner_ad---------------${true}");
        setState(() {
          faceBookBanner = value;
        });
      },
    );
  }
}

showRewardedAd(AdsFile? adsFile, Function function, {Function? function1}) {
  if (adsFile != null) {
    adsFile.showRewardedAd(() {
      function();
    }, () {
      if (function1 != null) {
        function1();
      }
    });
  }
}

disposeInterstitialAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeInterstitialAd();
  }
}

showInterstitialAd(AdsFile? adsFile, Function function, var setState) {
  // if (adsFile != null) {
  //   adsFile.showInterstitialAd(() {
  //     function();
  //   });
  // } else {
  //   function();
  // }
  if (adsFile != null) {
    adsFile.showInterstitialAd(() {
      function();
    }, setState);
  } else {
    function();
  }
}

disposeRewardedAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeRewardedAd();
  }
}

disposeBannerAd(AdsFile? adsFile) {
  if (adsFile != null) {
    adsFile.disposeBannerAd();
  }
}

Future<bool> checkInApp() async {
  bool isPurchase = await Preferences.preferences
      .getBool(key: PrefernceKey.isProUser, defValue: false);

  return isPurchase;
}

showBanner(AdsFile? adsFile) {
  // return adsFile == null
  //     ? Container()
  //     : Container(
  //       height: (getBannerAd(adsFile) != null)
  //           ? getBannerAd(adsFile)!.size.height.toDouble()
  //           : 0,
  //       color: Colors.white,
  //       child: (getBannerAd(adsFile) != null)
  //           ? AdWidget(ad: getBannerAd(adsFile)!)
  //           : Container(),
  //     );
  return adsFile == null
      ? Container()
      : Container(
          color: Colors.white,
          child: (adsFile.faceBookBanner != null)
              ? adsFile.faceBookBanner
              : Container(),
        );
}

BannerAd? getBannerAd(AdsFile? adsFile) {
  BannerAd? _anchoredBanner;
  if (adsFile != null) {
    return (adsFile._anchoredBanner == null)
        ? _anchoredBanner
        : adsFile._anchoredBanner!;
  } else {
    return _anchoredBanner!;
  }
}
