import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/semester_selection_screen.dart';
import 'package:gpatwo/screens/gpa_calculator.dart';

class GPATypeSelectionScreen extends StatefulWidget {
  final String department;

  const GPATypeSelectionScreen({
    Key? key,
    required this.department,
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
          ),
        ),
      );
    }
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
                          "Hesaplama türünü seçin",
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "GPA hesaplamasını nasıl yapmak istediğinizi seçin",
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

                const SizedBox(height: 40),

                // Hesaplama türü seçenekleri
                Expanded(
                  child: ListView.builder(
                    itemCount: calculationTypes.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedTypeIndex == index;

                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.2 * (index + 1)),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            0.2 * index,
                            0.2 * index + 0.6,
                            curve: Curves.easeOutQuint,
                          ),
                        )),
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.2 * index, 0.2 * index + 0.6),
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
                                    blurRadius: 15,
                                    spreadRadius: isSelected ? 2 : 0,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // İkon
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.15)
                                          : Colors.grey.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        calculationTypes[index]['icon'],
                                        size: 30,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
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
                                          style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          calculationTypes[index]['subtitle'],
                                          style: GoogleFonts.quicksand(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.8)
                                                : Colors.black54,
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
                                          ? Colors.white
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.black,
                                    )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                        onPressed: selectedTypeIndex != -1 ? navigateNext : null,
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