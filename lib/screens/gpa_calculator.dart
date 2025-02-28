import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPACalculatorScreen extends StatefulWidget {
  final String department;
  const GPACalculatorScreen({Key? key, required this.department}) : super(key: key);

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
    ],
  };

  Map<String, String?> selectedGrades = {};
  final List<String> gradeOptions = ['AA', 'BA', 'BB', 'CB', 'CC', 'DC', 'DD', 'FD', 'FF'];
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
        totalPoints += gradeValues[selectedGrades[courseName]]! * courseCredits;
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
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
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
