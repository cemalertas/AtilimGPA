import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const DepartmentSelectionScreen(),
    );
  }
}

class DepartmentSelectionScreen extends StatefulWidget {
  const DepartmentSelectionScreen({Key? key}) : super(key: key);

  @override
  _DepartmentSelectionScreenState createState() =>
      _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState
    extends State<DepartmentSelectionScreen> {
  String? selectedDepartment;
  final List<String> departments = [
    'Computer Engineering',
    'Electrical Engineering',
    'Information Systems Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Software Engineering'
  ];

  void navigateToGPA() {
    if (selectedDepartment != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GPACalculatorScreen(department: selectedDepartment!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Your Department',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedDepartment,
                  items: departments.map((department) {
                    return DropdownMenuItem(
                        value: department, child: Text(department));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToGPA,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Continue',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GPACalculatorScreen extends StatefulWidget {
  final String department;
  const GPACalculatorScreen({Key? key, required this.department})
      : super(key: key);

  @override
  _GPACalculatorScreenState createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> {
  Map<String, List<Map<String, dynamic>>> departmentCourses = {
    'Computer Engineering': [
      {'name': 'Bilgisayar Programlama I', 'credits': 4.0},
      {'name': 'Genel Fizik I', 'credits': 6.0},
      {'name': 'Kalkülüs I', 'credits': 7.0},
      {'name': 'Veri Yapıları', 'credits': 8.0},
      {'name': 'İşletim Sistemleri', 'credits': 5.0},
    ],
  'Information Systems Engineering': [
  {'name': 'Bilgisayar Programlama I', 'credits': 4.0},
  {'name': 'Genel Fizik I', 'credits': 6.0},
  {'name': 'Kalkülüs I', 'credits': 7.0},
  {'name': 'Atatürk İlkeleri ve İnkılâp Tarihi I', 'credits': 2.0},
  {'name': 'Akademik İngilizce I', 'credits': 3.5},
  {'name': 'Hesaplamanın Temelleri', 'credits': 2.5},
  {'name': 'Genel Kimya', 'credits': 5.0},
  {'name': 'Kariyer Planlama', 'credits': 1.0},
  {'name': 'Üniversite Hayatına Giriş', 'credits': 1.0},
  {'name': 'Atatürk İlkeleri ve İnkılâp Tarihi II', 'credits': 2.0},
  {'name': 'Genel Fizik II', 'credits': 6.0},
  {'name': 'Uygarlık Tarihi', 'credits': 3.0},
  {'name': 'Akademik İngilizce II', 'credits': 3.5},
  {'name': 'Bilgisayar Programlama II', 'credits': 5.0},
  {'name': 'Yönetim Bilişim Sistemlerine Giriş', 'credits': 3.5},
  {'name': 'Kalkülüs II', 'credits': 7.0},
  {'name': 'Lineer Cebir', 'credits': 6.0},
  {'name': 'Akademik İngilizce III', 'credits': 3.0},
  {'name': 'İş ve e-Ticaret', 'credits': 6.0},
  {'name': 'Ayrık Hesaplamalı Yapılar', 'credits': 7.0},
  {'name': 'Nesne Tabanlı Programlama', 'credits': 8.0},
  {'name': 'Diferansiyel Denklemler', 'credits': 6.0},
  {'name': 'Olasılık ve İstatistik', 'credits': 5.0},
  {'name': 'Akademik İngilizce IV', 'credits': 3.0},
  {'name': 'İnsan Bilgisayar Etkileşimi', 'credits': 8.0},
  {'name': 'Veri Yapıları', 'credits': 8.0},
  {'name': 'İnternet Programlama', 'credits': 5.0},
  {'name': 'Yaz Stajı I', 'credits': 6.0},
  {'name': 'Bilgi Sistemleri Geliştirilmesi', 'credits': 10.0},
  {'name': 'Veritabanı Tasarım ve Yönetimi', 'credits': 7.0},
  {'name': 'Mühendislik Mesleğinin İlkeleri', 'credits': 3.0},
  {'name': 'Yazılım Mühendisliği', 'credits': 6.0},
  {'name': 'BT Altyapısı ve Mimarisi', 'credits': 5.0},
  {'name': 'Algoritma ve Optimizasyon Yöntemleri', 'credits': 5.0},
  {'name': 'Bilgisayar Ağları ve İşletim Sistemleri', 'credits': 6.0},
  {'name': 'Veri Ambarı ve Veri Madenciliği', 'credits': 5.0},
  {'name': 'İş Sağlığı ve Güvenliği', 'credits': 4.0},
  {'name': 'Türk Dili I', 'credits': 2.0},
  {'name': 'Yaz Stajı II', 'credits': 10.0},
  {'name': 'Pratik Makine Öğrenimi', 'credits': 5.0},
  {'name': 'Türk Dili II', 'credits': 2.0},
  {'name': 'Bitirme Projesi', 'credits': 9.0},
  {'name': 'Bilgisayar Güvenliği', 'credits': 5.0}
  ],
  };

  Map<String, String?> selectedGrades = {};
  final List<String> gradeOptions = [
    'AA',
    'BA',
    'BB',
    'CB',
    'CC',
    'DC',
    'DD',
    'FD',
    'FF'
  ];
  Map<String, double> gradeValues = {
    'AA': 4.0,
    'BA': 3.5,
    'BB': 3.0,
    'CB': 2.5,
    'CC': 2.0,
    'DC': 1.5,
    'DD': 1.0,
    'FD': 0.5,
    'FF': 0.0
  };

  void showGPAPopup() {
    double gpa = calculateGPA();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("GPA Sonucu",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          content: Text("GPA'nız: ${gpa.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  double calculateGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in departmentCourses[widget.department] ?? []) {
      String courseName = course['name'];
      double courseCredits = (course['credits'] as num).toDouble();
      if (selectedGrades[courseName] != null) {
        totalPoints +=
            gradeValues[selectedGrades[courseName]]! * courseCredits;
        totalCredits += courseCredits;
      }
    }
    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPA Calculator",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: departmentCourses[widget.department]?.length ?? 0,
              itemBuilder: (context, index) {
                var course = departmentCourses[widget.department]![index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 1)),
                  child: ListTile(
                    title: Text(course['name'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    subtitle: Text('Credits: ${course['credits']}'),
                    trailing: DropdownButton<String>(
                      value: selectedGrades[course['name']],
                      items: gradeOptions.map((grade) {
                        return DropdownMenuItem(
                            value: grade, child: Text(grade));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGrades[course['name']] = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: showGPAPopup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20),
              ),
              child: Text('GPA Hesapla',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
