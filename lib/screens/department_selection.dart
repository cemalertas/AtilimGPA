import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/gpa_calculator.dart';

class DepartmentSelectionScreen extends StatefulWidget {
  const DepartmentSelectionScreen({Key? key}) : super(key: key);

  @override
  _DepartmentSelectionScreenState createState() =>
      _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  final List<Map<String, dynamic>> departments = [
    {'name': 'Computer Engineering', 'icon': Icons.computer},
    {'name': 'Electrical Engineering', 'icon': Icons.electrical_services},
    {'name': 'Information Systems Engineering', 'icon': Icons.data_usage},
    {'name': 'Mechanical Engineering', 'icon': Icons.build},
    {'name': 'Civil Engineering', 'icon': Icons.foundation},
    {'name': 'Software Engineering', 'icon': Icons.code},
  ];

  int selectedDepartmentIndex = 0;

  void navigateToGPA(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GPACalculatorScreen(
          department: departments[index]['name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan gradient efekti
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // **Başlık Yukarıda ve Modern Font**
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Select Your Department',
                  style: GoogleFonts.englebert(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // **Yatay Kaydırmalı Bölüm Seçme**
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: departments.length,
                  controller: PageController(viewportFraction: 0.75),
                  onPageChanged: (index) {
                    setState(() {
                      selectedDepartmentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedDepartmentIndex;

                    return GestureDetector(
                      onTap: () => navigateToGPA(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(16),
                        width: 180,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.4), // Saydam Efekt
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.transparent,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              departments[index]['icon'],
                              size: isSelected ? 60 : 50,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              departments[index]['name'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: isSelected ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
