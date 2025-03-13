import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/auth_wrapper.dart';
import 'screens/language_theme_selection.dart';
import 'services/auth.dart';

// Global tema ve dil güncelleyici fonksiyonlar
void Function(bool)? globalUpdateTheme;
void Function(String)? globalUpdateLanguage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ['TEST_DEVICE_ID'],
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }

  final isDarkMode = prefs.getBool('dark_mode') ?? false;
  final language = prefs.getString('language') ?? 'tr';

  runApp(MyApp(
    isFirstLaunch: isFirstLaunch,
    isDarkMode: isDarkMode,
    language: language,
  ));
}

class MyApp extends StatefulWidget {
  final bool isFirstLaunch;
  final bool isDarkMode;
  final String language;

  const MyApp({
    Key? key,
    required this.isFirstLaunch,
    required this.isDarkMode,
    required this.language,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  late String _language;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _language = widget.language;

    // Global fonksiyonları tanımla
    globalUpdateTheme = updateTheme;
    globalUpdateLanguage = updateLanguage;
  }

  // Uygulamada tema değişikliğini uygulayacak metod
  void updateTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  // Uygulamada dil değişikliğini uygulayacak metod
  void updateLanguage(String language) {
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return CustomAuthProvider(
      auth: authService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GPA Calculator',

        // Localization desteği
        localizationsDelegates: const [
          // AppLocalizations.delegate, // Uygulama çevirileri için ekleyin (l10n kurulumundan sonra)
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // İngilizce
          Locale('tr'), // Türkçe
        ],
        locale: Locale(_language),

        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.poppins().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,  // Açık temada beyaz app bar
            foregroundColor: Colors.black,  // Açık temada siyah yazı
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,  // Açık temada beyaz
            selectedItemColor: Colors.black,  // Açık temada siyah simge (seçili)
            unselectedItemColor: Colors.grey.shade400,
            elevation: 8,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
          fontFamily: GoogleFonts.poppins().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade600,
            elevation: 8,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
          ),
          // Ek olarak GPA hesaplama ekranları için tema desteği
          cardColor: Colors.grey.shade900,
          dialogBackgroundColor: Colors.grey.shade900,
        ),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: widget.isFirstLaunch
            ? const LanguageThemeSelectionScreen(isFirstLaunch: true)
            : const AuthWrapper(),
      ),
    );
  }
}