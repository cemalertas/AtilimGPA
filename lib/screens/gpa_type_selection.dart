import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/semester_selection_screen.dart';
import 'package:gpatwo/screens/gpa_calculator.dart';
import 'package:gpatwo/models/curriculum_model.dart';
import 'dart:math'; // Import for min() function

class GPATypeSelectionScreen extends StatefulWidget {
  final String department;
  final Curriculum? curriculum;

  const GPATypeSelectionScreen({
    Key? key,
    required this.department,
    this.curriculum,
  }) : super(key: key);

  @override
  _GPATypeSelectionScreenState createState() => _GPATypeSelectionScreenState();
}

class _GPATypeSelectionScreenState extends State<GPATypeSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedTypeIndex = -1;

  final List<Map<String, dynamic>> calculationTypes = [
    {
      'title': 'Dönem Ortalaması',
      'subtitle': 'Tek bir dönem için GPA hesaplayın',
      'icon': Icons.calendar_today_rounded,
      'type': 'semester'
    },
    {
      'title': 'Genel Ortalama',
      'subtitle': 'Tüm dönemler için GPA hesaplayın',
      'icon': Icons.school_rounded,
      'type': 'cumulative'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    // Log curriculum data for debugging
    if (widget.curriculum != null) {
      print('📚 Müfredat yüklendi: ${widget.curriculum!.departmentName}');
      print('📊 Dönem sayısı: ${widget.curriculum!.semesters.length}');
      print('📝 Ders sayısı: ${widget.curriculum!.totalCourseCount}');
    } else {
      print('⚠️ Müfredat bulunamadı!');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateNext() {
    if (selectedTypeIndex == -1) return;

    if (calculationTypes[selectedTypeIndex]['type'] == 'semester') {
      // Dönem ortalaması seçildiyse, dönem seçim ekranına git
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SemesterSelectionScreen(
            department: widget.department,
            curriculum: widget.curriculum, // Pass the curriculum data
          ),
        ),
      );
    } else {
      // Genel ortalama seçildiyse, direkt hesaplama ekranına git
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GPACalculatorScreen(
            department: widget.department,
            calculationType: calculationTypes[selectedTypeIndex]['type'],
            curriculum: widget.curriculum, // Pass the curriculum data
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          "HESAPLAMA TÜRÜ",
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
        color: Colors.black,
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
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BÖLÜM",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey[400],
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

                // Curriculum info box if curriculum is loaded
                if (widget.curriculum != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Müfredat Yüklendi",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${widget.curriculum!.semesters.length} dönem, ${widget.curriculum!.totalCourseCount} ders",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
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
                          "Hesaplama türünü seçin",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "GPA hesaplamasını nasıl yapmak istediğinizi seçin",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Hesaplama türü seçenekleri
                Expanded(
                  child: ListView.builder(
                      itemCount: calculationTypes.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedTypeIndex == index;

                        // FIX: Ensure animation intervals don't exceed 1.0
                        double beginInterval = 0.2 * index;
                        double endInterval = min(1.0, 0.2 * index + 0.6);

                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.2 * (index + 1)),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              beginInterval,
                              endInterval,
                              curve: Curves.easeOutQuint,
                            ),
                          )),
                          child: FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(beginInterval, endInterval),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTypeIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: isSelected ? 1 : 0,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // İkon
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          calculationTypes[index]['icon'],
                                          size: 30,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Metin
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            calculationTypes[index]['title'],
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            calculationTypes[index]['subtitle'],
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.black.withOpacity(0.7)
                                                  : Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Seçim işareti
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey[600]!,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
                        onPressed: selectedTypeIndex != -1 ? navigateNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[700],
                          disabledForegroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'DEVAM ET',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Colors.black,
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
    );
  }
}