import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math';
import 'package:gpatwo/models/curriculum_model.dart'; // Add curriculum model import

class GPACalculatorScreen extends StatefulWidget {
  final String department;
  final String calculationType; // 'semester' veya 'cumulative'
  final int? semester; // Dönem numarası (dönem ortalaması hesaplarken)
  final Curriculum? curriculum; // Add curriculum parameter

  const GPACalculatorScreen({
    Key? key,
    required this.department,
    required this.calculationType,
    this.semester,
    this.curriculum, // Add curriculum parameter
  }) : super(key: key);

  @override
  _GPACalculatorScreenState createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Fallback course data if curriculum is not available
  Map<String, Map<int, List<Map<String, dynamic>>>> departmentSemesterCourses = {
    'Bilgisayar Mühendisliği': {
      1: [
        {'name': 'Bilgisayar Programlama I', 'code': 'CMPE101', 'credits': 4.0},
        {'name': 'Genel Fizik I', 'code': 'PHYS101', 'credits': 6.0},
        {'name': 'Kalkülüs I', 'code': 'MATH101', 'credits': 7.0},
        {'name': 'Akademik İngilizce I', 'code': 'ENG101', 'credits': 3.5},
        {'name': 'Bilgisayar Mühendisliğine Giriş', 'code': 'CMPE100', 'credits': 2.0},
      ],
      2: [
        {'name': 'Bilgisayar Programlama II', 'code': 'CMPE102', 'credits': 4.0},
        {'name': 'Genel Fizik II', 'code': 'PHYS102', 'credits': 6.0},
        {'name': 'Kalkülüs II', 'code': 'MATH102', 'credits': 7.0},
        {'name': 'Akademik İngilizce II', 'code': 'ENG102', 'credits': 3.5},
        {'name': 'Lineer Cebir', 'code': 'MATH201', 'credits': 3.0},
      ],
      // Other semesters...
    },
    // Other departments...
  };

  // Dynamically populated course list
  List<Map<String, dynamic>> courses = [];

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

    // Initialize courses based on curriculum data or fallback to hardcoded data
    _initializeCourses();
  }

  void _initializeCourses() {
    courses = []; // Reset courses list

    // First try to use curriculum data if available
    if (widget.curriculum != null) {
      print('📚 Using curriculum data for courses');
      print('📋 Total number of semesters in curriculum: ${widget.curriculum!.semesters.length}');

      if (widget.calculationType == 'semester' && widget.semester != null) {
        // Get courses for a specific semester
        print('🔍 Looking for semester ${widget.semester} (index ${widget.semester! - 1})');

        if (widget.semester! <= widget.curriculum!.semesters.length) {
          final semesterIndex = widget.semester! - 1; // Convert 1-based to 0-based index
          final semesterData = widget.curriculum!.semesters[semesterIndex];

          print('✅ Found semester ${widget.semester} with ${semesterData.lessons.length} lessons');

          // Debug: print first few lessons
          if (semesterData.lessons.isNotEmpty) {
            print('📝 Sample courses:');
            for (int i = 0; i < min(3, semesterData.lessons.length); i++) {
              print('  - ${semesterData.lessons[i].courseCode}: ${semesterData.lessons[i].courseName}');
            }
          }

          courses = semesterData.lessons.map((lesson) => {
            'name': lesson.courseName,
            'code': lesson.courseCode,
            'credits': lesson.ects,
          }).toList();

          print('✅ Loaded ${courses.length} courses for semester ${widget.semester}');
        } else {
          print('⚠️ Semester ${widget.semester} not found in curriculum (only ${widget.curriculum!.semesters.length} semesters available)');
          // Fallback to empty list or hardcoded data
          _loadFallbackCourses();
        }
      } else {
        // Get all courses for cumulative GPA
        print('🔍 Loading all courses for cumulative GPA');
        courses = [];
        int totalLessons = 0;

        for (var i = 0; i < widget.curriculum!.semesters.length; i++) {
          final semester = widget.curriculum!.semesters[i];
          totalLessons += semester.lessons.length;

          courses.addAll(semester.lessons.map((lesson) => {
            'name': lesson.courseName,
            'code': lesson.courseCode,
            'credits': lesson.ects,
          }).toList());
        }

        print('✅ Loaded ${courses.length} courses from ${widget.curriculum!.semesters.length} semesters (total lessons: $totalLessons)');
      }
    } else {
      print('⚠️ No curriculum data, using fallback data');
      _loadFallbackCourses();
    }

    // Safety check - if courses is still empty, use hardcoded default data
    if (courses.isEmpty) {
      print('⚠️ No courses loaded, using default fallback data');
      courses = [
        {'name': 'Bilgisayar Programlama I', 'code': 'CMPE101', 'credits': 4.0},
        {'name': 'Genel Fizik I', 'code': 'PHYS101', 'credits': 6.0},
        {'name': 'Kalkülüs I', 'code': 'MATH101', 'credits': 7.0},
        {'name': 'Akademik İngilizce I', 'code': 'ENG101', 'credits': 3.5},
      ];
    }
  }

  void _loadFallbackCourses() {
    if (widget.calculationType == 'semester' && widget.semester != null) {
      courses = departmentSemesterCourses[widget.department]?[widget.semester!] ?? [];
    } else {
      // Use all courses for cumulative GPA
      courses = [];
      final allSemesters = departmentSemesterCourses[widget.department] ?? {};
      for (var semesterCourses in allSemesters.values) {
        courses.addAll(semesterCourses);
      }
    }
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
        return Material(
          type: MaterialType.transparency,
          child: Center(
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
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      ),
                      child: Text(
                        "TAMAM",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
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

    for (var course in courses) {
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 28,
          ),
          splashRadius: 24,
          tooltip: 'Geri',
        ),
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

            // Hesaplama tipi bilgisi
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.calculationType == 'semester'
                        ? Icons.calendar_today_rounded
                        : Icons.school_rounded,
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.calculationType == 'semester'
                          ? "${widget.semester}. Dönem Ortalaması"
                          : "Genel Ortalama",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course count info
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: courses.isEmpty ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: courses.isEmpty ? Colors.red.shade200 : Colors.blue.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    courses.isEmpty ? Icons.warning_amber_rounded : Icons.info_outline,
                    color: courses.isEmpty ? Colors.red.shade700 : Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      courses.isEmpty
                          ? "Ders bulunamadı"
                          : "${courses.length} ders yüklendi",
                      style: GoogleFonts.montserrat(
                        color: courses.isEmpty ? Colors.red.shade800 : Colors.blue.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Curriculum info if available
            if (widget.curriculum != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Müfredat verisi kullanılıyor\n${widget.curriculum!.departmentName}",
                        style: GoogleFonts.montserrat(
                          color: Colors.green.shade800,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Dersler listesi
            Expanded(
              child: courses.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Bu dönem için ders bulunamadı.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Lütfen başka bir dönem seçin",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  var course = courses[index];
                  String courseName = course['name'];
                  String courseCode = course['code'] ?? '';
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
                          // Ders kodu (varsa)
                          if (courseCode.isNotEmpty)
                            Text(
                              courseCode,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),

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
                                  "${courseCredits.toStringAsFixed(1)} ECTS",
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
                onPressed: courses.isEmpty ? null : showGPAPopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade300,
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