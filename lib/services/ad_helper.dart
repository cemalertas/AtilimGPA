import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static bool _initialized = false;

  // Singleton pattern
  static final AdHelper _instance = AdHelper._internal();
  factory AdHelper() => _instance;
  AdHelper._internal();

  // Reklam ID'leri - TEST ID'lerini kullan
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test ID
    } else {
      throw UnsupportedError('Desteklenmeyen platform');
    }
  }

  // Gerçek ID (daha sonra kullanılmak üzere sakla)
  static String get realInterstitialAdUnitId => 'ca-app-pub-6558836941000176/1278913333';

  // Statik değişkenler
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdLoaded = false;
  static bool get isInterstitialReady => _isInterstitialAdLoaded;

  // Reklam SDK'sını başlat
  static Future<void> initialize() async {
    if (_initialized) return;

    await MobileAds.instance.initialize();
    _initialized = true;

    // İlk reklamı yükle
    loadInterstitialAd();
  }

  // Geçiş reklamını yükle
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;

          print('Test reklamı yüklendi! ID: ${interstitialAdUnitId}');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _isInterstitialAdLoaded = false;
              loadInterstitialAd(); // Yeniden yükle
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('Reklam gösterilemedi: $error');
              ad.dispose();
              _isInterstitialAdLoaded = false;
              loadInterstitialAd(); // Yeniden yükle
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial reklam yüklenemedi: ${error.message}');
          _isInterstitialAdLoaded = false;
          // Belirli bir süre sonra tekrar dene
          Future.delayed(const Duration(minutes: 1), () {
            loadInterstitialAd();
          });
        },
      ),
    );
  }

  // Geçiş reklamını göster
  static void showInterstitialAd({Function? onAdClosed}) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      // Reklam gösterilmeden önce eski callback'i sakla
      final oldCallback = _interstitialAd!.fullScreenContentCallback;

      // Yeni callback oluştur
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          // Kullanıcının callback'ini çağır
          if (onAdClosed != null) {
            onAdClosed();
          }

          // Eski callback'i çağır
          if (oldCallback?.onAdDismissedFullScreenContent != null) {
            oldCallback!.onAdDismissedFullScreenContent!(ad);
          }
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          // Hata durumunda da kullanıcının callback'ini çağır
          if (onAdClosed != null) {
            onAdClosed();
          }

          // Eski callback'i çağır
          if (oldCallback?.onAdFailedToShowFullScreenContent != null) {
            oldCallback!.onAdFailedToShowFullScreenContent!(ad, error);
          }
        },
      );

      // Reklamı göster
      _interstitialAd!.show();
    } else {
      print('Interstitial reklam hazır değil.');

      // Reklam hazır değilse, kullanıcının callback'ini çağır
      if (onAdClosed != null) {
        onAdClosed();
      }

      // Yeni reklam yüklemeyi dene
      loadInterstitialAd();
    }
  }

  // Kaynakları temizle
  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }
}