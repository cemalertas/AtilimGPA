import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math';
import 'package:gpatwo/models/curriculum_model.dart';
import 'package:gpatwo/services/ad_helper.dart';
import 'widgets/gpa_course_card.dart';
import 'widgets/gpa_edit_course_dialog.dart';
import 'widgets/gpa_add_course_dialog.dart';
import 'widgets/loading_dialog.dart';

class GPACalculatorScreen extends StatefulWidget {
  final String department;
  final String calculationType; // 'semester' or 'cumulative'
  final int? semester; // Semester number (when calculating semester GPA)
  final Curriculum? curriculum; // Add curriculum parameter

  const GPACalculatorScreen({
    Key? key,
    required this.department,
    required this.calculationType,
    this.semester,
    this.curriculum, // Add curriculum parameter
  }) : super(key: key);

  @override
  State<GPACalculatorScreen> createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isEditMode = false;

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

    // Ensure AdHelper is initialized and reklam is loaded
    AdHelper.initialize().then((_) {
      print("AdHelper initialized in GPACalculatorScreen");

      // Check if ad is loaded and available after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        print("🔍 Reklam durumu kontrol ediliyor...");
        print("Reklam hazır mı? ${AdHelper.isInterstitialReady ? 'EVET ✅' : 'HAYIR ❌'}");
      });
    });
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

  // Remove course function
  void _removeCourse(int index) {
    final removedCourse = courses[index];
    setState(() {
      courses.removeAt(index);
      // If the deleted course has a grade selected, remove it too
      if (selectedGrades.containsKey(removedCourse['name'])) {
        selectedGrades.remove(removedCourse['name']);
      }
    });

    // Show notification when course is removed
    _showRemoveNotification(removedCourse['name']);
  }

  // Show notification when a course is removed
  void _showRemoveNotification(String courseName) {
    final overlayState = Overlay.of(context);

    // Declare overlayEntry variable first
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Color(0xFFFF7B7B), // Daha açık, pastel kırmızı
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '"$courseName" dersi kaldırıldı.',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        overlayEntry.remove();
                      },
                      child: Text(
                        'TAMAM',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

    // Add the overlay entry and remove after the duration
    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // Edit course function
  void _editCourse(int index) {
    final course = courses[index];

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => GPAEditCourseDialog(
        course: course,
        onSave: (updatedCourse) {
          final oldName = course['name'];
          final newName = updatedCourse['name'];

          setState(() {
            // If course name changed, transfer grade info to new name
            if (oldName != newName && selectedGrades.containsKey(oldName)) {
              final grade = selectedGrades[oldName];
              selectedGrades.remove(oldName);
              selectedGrades[newName] = grade;
            }

            courses[index] = updatedCourse;
          });
        },
      ),
    );
  }

  // Add new course function
  void _addNewCourse() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => GPAAddCourseDialog(
        onAdd: (newCourse) {
          setState(() {
            courses.add(newCourse);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Önce reklam göster ve sonra sonucu göster
  void showGPAPopup() {
    // Yükleme diyaloğunu göster
    LoadingDialog.show(context, message: 'GPA hesaplanıyor...');

    // Kısa bir gecikme ekleyerek yükleme diyaloğunun görünmesini sağla
    Future.delayed(const Duration(milliseconds: 500), () {
      // Yükleme diyaloğunu kapat
      if (Navigator.canPop(context)) {
        LoadingDialog.hide(context);
      }

      // AdHelper kullanarak reklamı göster
      AdHelper.showInterstitialAd(onAdClosed: () {
        // Reklam kapandığında sonucu göster
        _showGPAResult();
      });
    });
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.5) return Colors.green.shade600;
    if (gpa >= 3.0) return Colors.green.shade500;
    if (gpa >= 2.5) return Colors.green.shade400;
    if (gpa >= 2.0) return Colors.yellow.shade700;
    if (gpa >= 1.5) return Colors.orange.shade600;
    if (gpa >= 1.0) return Colors.orange.shade800;
    return Colors.red.shade600;
  }

  String _getGradeFromGPA(double gpa) {
    if (gpa >= 3.5) return "PUAN";
    if (gpa >= 3.0) return "PUAN";
    if (gpa >= 2.5) return "PUAN";
    if (gpa >= 2.0) return "PUAN";
    if (gpa >= 1.0) return "PUAN";
    return "BAŞARISIZ";
  }

  double _getPerformancePercentage(double gpa) {
    // Convert GPA to percentage (4.0 GPA = 100%)
    double percentage = (gpa / 4.0) * 100;
    return percentage.clamp(0, 100); // Ensure value is between 0 and 100
  }

  // GPA sonucunu göster - GPAResultDialog widget'ı yerine doğrudan dialog tanımlandı
  void _showGPAResult() {
    double gpa = calculateGPA();
    final performancePercentage = _getPerformancePercentage(gpa);

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
        // GPAResultDialog yerine doğrudan Dialog widget'ı tanımlandı
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade800, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GPA Result Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2818),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                      color: Colors.green.shade900,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "GPA SONUCU",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            gpa.toStringAsFixed(2),
                            style: GoogleFonts.montserrat(
                              color: _getGPAColor(gpa),
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getGPAColor(gpa).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getGPAColor(gpa).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getGradeFromGPA(gpa),
                              style: GoogleFonts.poppins(
                                color: _getGPAColor(gpa),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Message and performance indicator
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Performance message with trophy icon
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events_rounded,
                            color: Colors.green.shade400,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getGPAMessage(gpa),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Performance label and percentage
                      Row(
                        children: [
                          Text(
                            "Performans",
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${performancePercentage.toInt()}%",
                            style: GoogleFonts.poppins(
                              color: Colors.green.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: performancePercentage / 100,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getGPAColor(gpa),
                          ),
                          minHeight: 10,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // İki buton yan yana: Kapat ve Ana Sayfa
                      Row(
                        children: [
                          // KAPAT butonu
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade800,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "KAPAT",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // ANA SAYFA butonu
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Önce diyaloğu kapat
                                  Navigator.of(context).pop();
                                  // Tüm ekranları kapat ve ana sayfaya git
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "ANA SAYFA",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
      backgroundColor: Colors.black,
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 28,
          ),
          splashRadius: 24,
          tooltip: 'Geri',
        ),
        actions: [
          // Edit mode toggle button
          IconButton(
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            icon: Icon(
              _isEditMode ? Icons.done : Icons.edit,
              color: Colors.white,
              size: 24,
            ),
            splashRadius: 24,
            tooltip: _isEditMode ? 'Düzenlemeyi Bitir' : 'Dersleri Düzenle',
          ),
        ],
      ),
      // Add new course button (visible in edit mode)
      floatingActionButton: _isEditMode
          ? FloatingActionButton(
        onPressed: _addNewCourse,
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: 'Yeni Ders Ekle',
      )
          : null,
      body: Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black,
        Color(0xFF121212),
      ],
    ),
    ),
    child: Column(
    children: [
    // Department info
    Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.grey.shade900,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade800),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "BÖLÜM",
    style: GoogleFonts.montserrat(
    color: Colors.grey.shade400,
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

    // Calculation type info
    Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: Colors.grey.shade800,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
    color: Colors.grey.shade700,width: 1,
    ),
    ),
      child: Row(
        children: [
          Icon(
            widget.calculationType == 'semester'
                ? Icons.calendar_today_rounded
                : Icons.school_rounded,
            color: Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.calculationType == 'semester'
                  ? "${widget.semester}. Dönem Ortalaması"
                  : "Genel Ortalama",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_isEditMode)
            Chip(
              label: Text(
                "Düzenleme Modu",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
        ],
      ),
    ),

      // Course list
      Expanded(
        child: courses.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return GPACourseCard(
              course: courses[index],
              isEditMode: _isEditMode,
              selectedGrade: selectedGrades[courses[index]['name']],
              gradeOptions: gradeOptions,
              gradeColors: gradeColors,
              gradeValues: gradeValues,
              onGradeChanged: (courseName, value) {
                setState(() {
                  selectedGrades[courseName] = value;
                });
              },
              onEdit: () => _editCourse(index),
              onRemove: () => _removeCourse(index),
            );
          },
        ),
      ),

      // Calculate button - hidden in edit mode
      if (!_isEditMode)
        Container(
          margin: const EdgeInsets.all(24),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: courses.isEmpty ? null : showGPAPopup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey.shade700,
              disabledForegroundColor: Colors.grey.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              shadowColor: Colors.white.withOpacity(0.1),
            ),
            child: Text(
              'GPA HESAPLA',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
    ],
    ),
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isEditMode ? Icons.add_circle_outline : Icons.search_off_rounded,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            _isEditMode
                ? "Ders eklemek için + butonuna tıklayın"
                : "Bu dönem için ders bulunamadı.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
            textAlign: TextAlign.center,
          ),
          if (!_isEditMode)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Lütfen başka bir dönem seçin",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}