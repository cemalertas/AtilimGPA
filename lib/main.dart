import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth_wrapper.dart';
import 'screens/language_theme_selection.dart';
import 'services/auth.dart';

void main() async {
  // Flutter engine'i başlat (Firebase'den önce gerekli)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp();

  // İlk çalıştırma kontrolü
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

  // İlk çalıştırma ise, bayrağı güncelle
  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }

  // Tema ve dil tercihlerini yükle
  final isDarkMode = prefs.getBool('dark_mode') ?? false;
  final language = prefs.getString('language') ?? 'tr';

  // Uygulamayı çalıştır
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
  }

  @override
  Widget build(BuildContext context) {
    // Auth servisini oluştur
    final AuthService authService = AuthService();

    return CustomAuthProvider(
      auth: authService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GPA Calculator',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
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
        ),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        // İlk çalıştırmada dil ve tema seçim ekranı, sonraki çalıştırmalarda auth wrapper
        home: widget.isFirstLaunch
            ? const LanguageThemeSelectionScreen(isFirstLaunch: true)
            : const AuthWrapper(),
        locale: Locale(_language),
      ),
    );
  }
}