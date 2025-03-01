import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class GPACalculatorScreen extends StatefulWidget {
  final String department;
  const GPACalculatorScreen({Key? key, required this.department}) : super(key: key);

  @override
  _GPACalculatorScreenState createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
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
  final Map<String, Color> gradeColors = {
    'AA': Colors.green.shade700,
    'BA': Colors.green.shade500,
    'BB': Colors.green.shade300,
    'CB': Colors.yellow.shade700,
    'CC': Colors.yellow.shade500,
    'DC': Colors.orange.shade400,
    'DD': Colors.orange.shade600,
    'FD': Colors.red.shade400,
    'FF': Colors.red.shade700,
  };
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showGPAPopup() {
    double gpa = calculateGPA();

    // GPA için bir renk belirle
    Color gpaColor = Colors.red;
    if (gpa >= 3.5) {
      gpaColor = Colors.green.shade700;
    } else if (gpa >= 3.0) {
      gpaColor = Colors.green.shade500;
    } else if (gpa >= 2.5) {
      gpaColor = Colors.green.shade300;
    } else if (gpa >= 2.0) {
      gpaColor = Colors.yellow.shade700;
    } else if (gpa >= 1.5) {
      gpaColor = Colors.orange.shade400;
    } else if (gpa >= 1.0) {
      gpaColor = Colors.orange.shade600;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "GPA Result",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başlık
                  Text(
                    "GPA SONUCU",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // GPA değeri
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: gpaColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: gpaColor,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            gpa.toStringAsFixed(2),
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: gpaColor,
                            ),
                          ),
                          Text(
                            "PUAN",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: gpaColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sonuç mesajı
                  Text(
                    _getGPAMessage(gpa),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Kapat butonu
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "TAMAM",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getGPAMessage(double gpa) {
    if (gpa >= 3.5) return "Harika! Mükemmel bir performans gösterdiniz!";
    if (gpa >= 3.0) return "Çok iyi! Çalışmalarınız meyvesini veriyor!";
    if (gpa >= 2.5) return "İyi! Biraz daha çalışmayla daha da yükselebilir!";
    if (gpa >= 2.0) return "Ortalama. Dikkatli olmalısınız!";
    if (gpa >= 1.5) return "Geçtiniz, ancak daha fazla çaba göstermelisiniz!";
    if (gpa >= 1.0) return "Sınırda geçtiniz. Daha çok çalışmalısınız!";
    return "Başarısız oldunuz. Daha fazla destek almalısınız!";
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
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "GPA CALCULATOR",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade100,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Bölüm bilgisi
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BÖLÜM",
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.department,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Dersler listesi
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: departmentCourses[widget.department]?.length ?? 0,
                itemBuilder: (context, index) {
                  var course = departmentCourses[widget.department]![index];
                  String courseName = course['name'];
                  double courseCredits = (course['credits'] as num).toDouble();
                  String? selectedGrade = selectedGrades[courseName];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: selectedGrade != null
                          ? gradeColors[selectedGrade]!.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: selectedGrade != null
                            ? gradeColors[selectedGrade]!
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ders adı
                          Text(
                            courseName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Ders bilgileri ve not seçici
                          Row(
                            children: [
                              // Kredi bilgisi
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${courseCredits.toStringAsFixed(1)} kredi",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const Spacer(),

                              // Not seçici
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedGrade != null
                                      ? gradeColors[selectedGrade]!.withOpacity(0.1)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedGrade != null
                                        ? gradeColors[selectedGrade]!
                                        : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGrade,
                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        "Not Seç",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: selectedGrade != null
                                          ? gradeColors[selectedGrade]
                                          : Colors.grey,
                                    ),
                                    elevation: 1,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: selectedGrade != null
                                          ? gradeColors[selectedGrade]
                                          : Colors.black87,
                                    ),
                                    dropdownColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    items: gradeOptions.map((grade) {
                                      return DropdownMenuItem(
                                        value: grade,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            grade,
                                            style: GoogleFonts.poppins(
                                              color: gradeColors[grade],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGrades[courseName] = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Not bilgisi (eğer seçilmişse)
                          if (selectedGrade != null)
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: gradeColors[selectedGrade]!.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: gradeColors[selectedGrade]!.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Not Değeri: ${gradeValues[selectedGrade]!.toStringAsFixed(1)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: gradeColors[selectedGrade],
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

            // Hesaplama butonu
            Container(
              margin: const EdgeInsets.all(24),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: showGPAPopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.4),
                ),
                child: Text(
                  'GPA HESAPLA',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}