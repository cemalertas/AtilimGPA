import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth.dart';
import 'services/lesson_fetcher.dart'; // Import the DataService

void main() async {
  // Flutter engine'i başlat (Firebase'den önce gerekli)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp();

  // Test the DataService
  await testDataService();

  // Uygulamayı çalıştır
  runApp(const MyApp());
}

// Function to test the DataService
Future<void> testDataService() async {
  print('📊 Testing DataService...');
  final DataService dataService = DataService();

  try {
    // Test fetching curriculum
    print('🔍 Testing fetchCurriculum method...');
    final curriculumData = await dataService.fetchCurriculum();
    print('✅ Curriculum data fetched successfully!');
    print('📋 Number of semesters: ${curriculumData.length}');

    // Test fetching a specific course detail (if curriculum has data)
    if (curriculumData.isNotEmpty &&
        curriculumData[0]['data'] != null &&
        (curriculumData[0]['data'] as List).isNotEmpty) {

      // Extract first course code from the data
      final firstCourseData = (curriculumData[0]['data'] as List<Map<String, String>>).first;
      final headers = curriculumData[0]['headers'] as List<String>;

      // Find the course code column (might be named differently)
      String? courseCodeKey;
      for (var header in headers) {
        if (header.contains('Kod') || header.contains('Code')) {
          courseCodeKey = header;
          break;
        }
      }

      if (courseCodeKey != null && firstCourseData.containsKey(courseCodeKey)) {
        final courseCode = firstCourseData[courseCodeKey];
        if (courseCode != null && courseCode.isNotEmpty) {
          print('🔍 Testing fetchCourseDetails for course: $courseCode');
          final courseDetails = await dataService.fetchCourseDetails(courseCode);

          if (courseDetails != null) {
            print('✅ Course details fetched successfully!');
            print('📝 Course title: ${courseDetails['title']}');
          } else {
            print('⚠️ Course details not found for: $courseCode');
          }
        }
      }
    }
  } catch (e) {
    print('❌ Error testing DataService: $e');
  }
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
        home: const LoginScreen(), // Giriş ekranı başlangıç sayfası
      ),
    );
  }
}