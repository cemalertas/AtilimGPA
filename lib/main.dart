import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth.dart';


void main() async {
  // Flutter engine'i başlat (Firebase'den önce gerekli)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp();

  // Uygulamayı çalıştır
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Auth servisini oluştur
    final AuthService authService = AuthService();

    return AuthProvider(
      auth: authService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GPA Calculator',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const LoginScreen(), // Giriş ekranı başlaçngıç sayfası
      ),
    );
  }
}