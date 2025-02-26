import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.grey[200]!,
        lightSource: LightSource.topLeft,
        depth: 4,
        defaultTextColor: Colors.black,
      ),
      home: const DepartmentSelectionScreen(),
    );
  }
}

class DepartmentSelectionScreen extends StatefulWidget {
  const DepartmentSelectionScreen({Key? key}) : super(key: key);

  @override
  _DepartmentSelectionScreenState createState() => _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  String? selectedDepartment;
  final List<String> departments = [
    'Computer Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Software Engineering'
  ];

  void navigateToGPA() {
    if (selectedDepartment != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GPACalculatorScreen(department: selectedDepartment!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/gpawp.avif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select Your Department', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 20),
                  Neumorphic(
                    style: const NeumorphicStyle(depth: -4, intensity: 0.7),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedDepartment,
                      items: departments.map((department) {
                        return DropdownMenuItem(value: department, child: Text(department));
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
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  };

  Map<String, String?> selectedGrades = {};
  final List<String> gradeOptions = ['AA', 'BA', 'BB', 'CB', 'CC', 'DC', 'DD', 'FD', 'FF'];
  Map<String, double> gradeValues = {
    'AA': 4.0, 'BA': 3.5, 'BB': 3.0, 'CB': 2.5, 'CC': 2.0,
    'DC': 1.5, 'DD': 1.0, 'FD': 0.5, 'FF': 0.0
  };

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
        title: Text('${widget.department} GPA Calculation', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(course['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    subtitle: Text('Credits: ${course['credits']}'),
                    trailing: DropdownButton<String>(
                      value: selectedGrades[course['name']],
                      items: gradeOptions.map((grade) {
                        return DropdownMenuItem(value: grade, child: Text(grade));
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
            child: Text('Your GPA: ${calculateGPA().toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}
