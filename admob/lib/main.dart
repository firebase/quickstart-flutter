import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(state: ApplicationState()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.state});

  final ApplicationState state;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Quickstart',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AdMob Quickstart', state: state),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.state});

  final ApplicationState state;

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, child) => Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(64.0),
              child: Image(
                image: AssetImage('assets/logo-standard.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  'AdMob is Googles mobile advertising platform that you'
                  ' can use to generate revenue from your app. Using AdMob with '
                  'Firebase provides you with additional app usage data and '
                  'analytics capabilities.'),
            ),
            ElevatedButton(
              onPressed: state.interstitialAd != null
                  ? () {
                      state.showInterstitial();
                    }
                  : null,
              child: const Text('Load Interstitial'),
            ),
            const Expanded(child: SizedBox.shrink()),
            state.bannerAd != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: state.bannerAd!.size.width.toDouble(),
                      height: state.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: state.bannerAd!),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;

  InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;

  Future<void> init() async {
    MobileAds.instance.initialize();

    // // Examples of all the listeners that can be called and acted upon.
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        _bannerAd = ad as BannerAd?;
        notifyListeners();
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    loadBannerAd(listener);
    loadInterstitialAd();
  }

  String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    // return an iOS ad unit
    return 'ca-app-pub-3940256099942544/2934735716';
  }

  String getInterstitialAdUnit() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    // return an iOS ad unit
    return 'ca-app-pub-3940256099942544/4411468910';
  }

  void loadBannerAd(BannerAdListener listener) {
    print('loading banner ad');
    final BannerAd myBanner = BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );
    myBanner.load();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getInterstitialAdUnit(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          fullscreenContentCallback(ad);
          _interstitialAd = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void fullscreenContentCallback(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadInterstitialAd();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
  }

  void showInterstitial() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }
}
