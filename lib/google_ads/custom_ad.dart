import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:women_lose_weight_flutter/google_ads/ad_helper.dart';
import 'package:women_lose_weight_flutter/utils/debug.dart';

import '../utils/utils.dart';

/// <><><><><> ================ BANNER AD ================ <><><><><> ///

class BannerAdClass extends StatefulWidget {
  const BannerAdClass({Key? key}) : super(key: key);

  @override
  State<BannerAdClass> createState() => _BannerAdClassState();
}

class _BannerAdClassState extends State<BannerAdClass> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _loadBanner();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Debug.googleAd && _bannerAd != null && _isBannerAdReady && !Utils.isPurchased())
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
        : const SizedBox();
  }

  _loadBanner() {
    if (Debug.googleAd && !Utils.isPurchased()) {
      _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            Debug.printLog('$ad loaded: ${ad.responseInfo}');
            _bannerAd = ad as BannerAd;
            _isBannerAdReady = true;
            setState(() {});
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            Debug.printLog('Anchored adaptive banner failedToLoad: $error');
            ad.dispose();
          },
        ),
      );
      return _bannerAd!.load();
    }
  }
}
