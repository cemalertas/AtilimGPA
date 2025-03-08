import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/gpa_calculator.dart';
import 'package:gpatwo/models/curriculum_model.dart';
import 'dart:math'; // Import for min() function
import 'dart:async'; // Import for Timer

class SemesterSelectionScreen extends StatefulWidget {
  final String department;
  final Curriculum? curriculum;

  const SemesterSelectionScreen({
    Key? key,
    required this.department,
    this.curriculum,
  }) : super(key: key);

  @override
  _SemesterSelectionScreenState createState() => _SemesterSelectionScreenState();
}

class _SemesterSelectionScreenState extends State<SemesterSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedSemester = -1;
  bool _showNotification = false; // Flag to control notification visibility
  Timer? _notificationTimer;

  // Static semester list for when curriculum isn't available
  final List<Map<String, dynamic>> defaultSemesters = [
    {'semester': 1, 'title': '1. Dönem', 'subtitle': 'Birinci Sınıf Güz Dönemi'},
    {'semester': 2, 'title': '2. Dönem', 'subtitle': 'Birinci Sınıf Bahar Dönemi'},
    {'semester': 3, 'title': '3. Dönem', 'subtitle': 'İkinci Sınıf Güz Dönemi'},
    {'semester': 4, 'title': '4. Dönem', 'subtitle': 'İkinci Sınıf Bahar Dönemi'},
    {'semester': 5, 'title': '5. Dönem', 'subtitle': 'Üçüncü Sınıf Güz Dönemi'},
    {'semester': 6, 'title': '6. Dönem', 'subtitle': 'Üçüncü Sınıf Bahar Dönemi'},
    {'semester': 7, 'title': '7. Dönem', 'subtitle': 'Dördüncü Sınıf Güz Dönemi'},
    {'semester': 8, 'title': '8. Dönem', 'subtitle': 'Dördüncü Sınıf Bahar Dönemi'},
  ];

  // Will store our actual semesters (either from curriculum or defaults)
  late List<Map<String, dynamic>> semesters;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Initialize semesters from curriculum data if available
    _initializeSemesters();

    // Show notification if curriculum is available
    if (widget.curriculum != null) {
      setState(() {
        _showNotification = true;
      });

      // Set a timer to hide the notification after 3 seconds
      _notificationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showNotification = false;
          });
        }
      });
    }
  }

  void _initializeSemesters() {
    if (widget.curriculum != null) {
      print('📚 Müfredat verisi bulundu. Dönemler hazırlanıyor...');

      // Create semester list from curriculum data
      semesters = List.generate(widget.curriculum!.semesters.length, (index) {
        final semester = widget.curriculum!.semesters[index];
        final year = ((index + 1) ~/ 2) + 1;
        final seasonTerm = (index % 2 == 0) ? 'Güz' : 'Bahar';
        final yearName = _getYearName(year);

        return {
          'semester': index + 1,
          'title': '${index + 1}. Dönem',
          'subtitle': '$yearName Sınıf $seasonTerm Dönemi',
          'courseCount': semester.lessons.length,
          'totalECTS': semester.totalEcts,
        };
      });

      print('✅ ${semesters.length} dönem hazırlandı.');
    } else {
      print('⚠️ Müfredat verisi bulunamadı. Varsayılan dönemler kullanılıyor.');
      semesters = defaultSemesters;
    }
  }

  // Helper method to get year name in Turkish
  String _getYearName(int year) {
    switch (year) {
      case 1:
        return 'Birinci';
      case 2:
        return 'İkinci';
      case 3:
        return 'Üçüncü';
      case 4:
        return 'Dördüncü';
      default:
        return '$year.';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationTimer?.cancel(); // Cancel timer if active
    super.dispose();
  }

  void navigateToGPACalculator() {
    if (selectedSemester == -1) return;

    // FIX: Pass the curriculum data to the GPACalculatorScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GPACalculatorScreen(
          department: widget.department,
          calculationType: 'semester',
          semester: selectedSemester,
          curriculum: widget.curriculum, // Pass the curriculum data
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
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
        title: Text(
          "DÖNEM SEÇİN",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Department info (black box at the top)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Başlık ve açıklama
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOutQuad,
                      )),
                      child: FadeTransition(
                        opacity: _animationController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hangi dönem için hesaplama yapmak istiyorsunuz?",
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Hesaplamak istediğiniz dönemi seçin",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Dönem seçimi grid - Düzeltilmiş (eşit hizada kartlar)
                    Expanded(
                      child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              // Increase the childAspectRatio to make cells taller
                              childAspectRatio: 1.0, // Changed from 1.2 to 1.0 to give more vertical space
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: List.generate(semesters.length, (index) {
                                bool isSelected = selectedSemester == semesters[index]['semester'];

                                // FIX: Ensure animation intervals don't exceed 1.0
                                double startInterval = 0.1 * index;
                                double endInterval = min(1.0, 0.1 * index + 0.5);

                                return FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(startInterval, endInterval),
                                    ),
                                  ),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(startInterval, endInterval, curve: Curves.easeOutQuint),
                                    )),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSemester = semesters[index]['semester'];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Reduced padding
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isSelected
                                                ? [Color(0xFF262626), Color(0xFF0D0D0D)]
                                                : [Colors.white, Colors.white],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? Colors.black.withOpacity(0.3)
                                                  : Colors.black.withOpacity(0.05),
                                              blurRadius: 10,
                                              spreadRadius: isSelected ? 1 : 0,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : Colors.grey.shade200,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min, // Added to prevent expansion
                                          children: [
                                            // Dönem numarası
                                            Container(
                                              width: 40, // Slightly reduced size
                                              height: 40, // Slightly reduced size
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white.withOpacity(0.2)
                                                    : Colors.grey.shade50,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.white.withOpacity(0.6)
                                                      : Colors.grey.shade300,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  semesters[index]['semester'].toString(),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 18, // Slightly reduced font size
                                                    fontWeight: FontWeight.w700,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8), // Reduced spacing

                                            // Dönem başlığı
                                            Text(
                                              semesters[index]['title'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 14, // Reduced font size
                                                fontWeight: FontWeight.w700,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),

                                            const SizedBox(height: 2), // Reduced spacing

                                            // Dönem alt başlığı
                                            Text(
                                              semesters[index]['subtitle'],
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 10, // Reduced font size
                                                fontWeight: FontWeight.w500,
                                                color: isSelected
                                                    ? Colors.white.withOpacity(0.8)
                                                    : Colors.black54,
                                              ),
                                            ),

                                            // Display course count if curriculum is available
                                            if (widget.curriculum != null && semesters[index]['courseCount'] != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4), // Reduced padding
                                                child: Text(
                                                  "${semesters[index]['courseCount']} ders",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: isSelected
                                                        ? Colors.white.withOpacity(0.7)
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }
                      ),
                    ),

                    // Devam butonu
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.6, 1.0, curve: Curves.easeOutQuad),
                      )),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.6, 1.0),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: selectedSemester != -1 ? navigateToGPACalculator : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            child: Text(
                              'DEVAM ET',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Temporary notification that appears and disappears
          if (_showNotification)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          "Müfredat Yüklendi: ${widget.curriculum!.totalCourseCount} ders",
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
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
    );
  }
}