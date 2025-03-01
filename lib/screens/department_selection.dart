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
    {'name': 'Computer Engineering', 'icon': Icons.computer_rounded},
    {'name': 'Electrical Engineering', 'icon': Icons.bolt_rounded},
    {'name': 'Information Systems Engineering', 'icon': Icons.storage_rounded},
    {'name': 'Mechanical Engineering', 'icon': Icons.precision_manufacturing_rounded},
    {'name': 'Civil Engineering', 'icon': Icons.domain_rounded},
    {'name': 'Software Engineering', 'icon': Icons.code_rounded},
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Başlık - Daha yukarıda ve daha şık
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text(
                  'SELECT YOUR DEPARTMENT',
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Açıklama metni
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Text(
                  'Choose your department to calculate GPA',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // İyileştirilmiş Kartlar
              Expanded(
                child: PageView.builder(
                  itemCount: departments.length,
                  controller: PageController(
                    viewportFraction: 0.8,
                    initialPage: selectedDepartmentIndex,
                  ),
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
                        curve: Curves.easeOutQuint,
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: isSelected ? 20 : 40,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isSelected
                                ? [Color(0xFF262626), Color(0xFF0D0D0D)]
                                : [Colors.white, Colors.grey.shade50],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.35)
                                  : Colors.black.withOpacity(0.08),
                              blurRadius: 25,
                              spreadRadius: isSelected ? 2 : 0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Üst kısım - İkon
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isSelected
                                        ? [Color(0xFF333333), Color(0xFF1A1A1A)]
                                        : [Colors.grey.shade100, Colors.grey.shade50],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: isSelected ? 130 : 110,
                                    height: isSelected ? 130 : 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isSelected
                                            ? [Colors.grey.shade800, Colors.white]
                                            : [Colors.grey.shade100, Colors.white],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? Colors.black.withOpacity(0.2)
                                              : Colors.black.withOpacity(0.1),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        departments[index]['icon'],
                                        size: isSelected ? 70 : 55,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Alt kısım - İsim
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: isSelected
                                        ? [Color(0xFF1A1A1A), Colors.black]
                                        : [Colors.white, Colors.grey.shade50],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        departments[index]['name'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          fontSize: isSelected ? 20 : 17,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),

                                      // Daha belirgin Select butonu
                                      if (isSelected)
                                        Container(
                                          margin: const EdgeInsets.only(top: 16),
                                          child: ElevatedButton(
                                            onPressed: () => navigateToGPA(index),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 8,
                                              shadowColor: Colors.black.withOpacity(0.3),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 36,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text(
                                              'SELECT',
                                              style: GoogleFonts.raleway(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Sayfa göstergesi
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    departments.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: index == selectedDepartmentIndex ? 24 : 8,
                      decoration: BoxDecoration(
                        color: index == selectedDepartmentIndex
                            ? Colors.black
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}