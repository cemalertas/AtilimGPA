import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/gpa_calculator.dart';

class SemesterSelectionScreen extends StatefulWidget {
  final String department;

  const SemesterSelectionScreen({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  _SemesterSelectionScreenState createState() => _SemesterSelectionScreenState();
}

class _SemesterSelectionScreenState extends State<SemesterSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedSemester = -1;

  final List<Map<String, dynamic>> semesters = [
    {'semester': 1, 'title': '1. Dönem', 'subtitle': 'Birinci Sınıf Güz Dönemi'},
    {'semester': 2, 'title': '2. Dönem', 'subtitle': 'Birinci Sınıf Bahar Dönemi'},
    {'semester': 3, 'title': '3. Dönem', 'subtitle': 'İkinci Sınıf Güz Dönemi'},
    {'semester': 4, 'title': '4. Dönem', 'subtitle': 'İkinci Sınıf Bahar Dönemi'},
    {'semester': 5, 'title': '5. Dönem', 'subtitle': 'Üçüncü Sınıf Güz Dönemi'},
    {'semester': 6, 'title': '6. Dönem', 'subtitle': 'Üçüncü Sınıf Bahar Dönemi'},
    {'semester': 7, 'title': '7. Dönem', 'subtitle': 'Dördüncü Sınıf Güz Dönemi'},
    {'semester': 8, 'title': '8. Dönem', 'subtitle': 'Dördüncü Sınıf Bahar Dönemi'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToGPACalculator() {
    if (selectedSemester == -1) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GPACalculatorScreen(
          department: widget.department,
          calculationType: 'semester',
          semester: selectedSemester,
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        double itemWidth = (constraints.maxWidth - 15) / 2;
                        double itemHeight = itemWidth / 1.2;

                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(semesters.length, (index) {
                            bool isSelected = selectedSemester == semesters[index]['semester'];

                            return FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(0.1 * index, 0.1 * index + 0.5),
                                ),
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(0.1 * index, 0.1 * index + 0.5, curve: Curves.easeOutQuint),
                                )),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSemester = semesters[index]['semester'];
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(15),
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
                                      children: [
                                        // Dönem numarası
                                        Container(
                                          width: 45,
                                          height: 45,
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Dönem başlığı
                                        Text(
                                          semesters[index]['title'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        // Dönem alt başlığı
                                        Text(
                                          semesters[index]['subtitle'],
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.8)
                                                : Colors.black54,
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
    );
  }
}