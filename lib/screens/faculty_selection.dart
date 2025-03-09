import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/department_selection.dart';

class FacultySelectionScreen extends StatefulWidget {
  const FacultySelectionScreen({Key? key}) : super(key: key);

  @override
  _FacultySelectionScreenState createState() => _FacultySelectionScreenState();
}

class _FacultySelectionScreenState extends State<FacultySelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedFacultyIndex = -1;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> faculties = [
    {
      'name': 'Mühendislik Fakültesi',
      'icon': Icons.engineering,
      'departments': [
        'Bilgisayar Mühendisliği',
        'Bilişim Sistemleri Mühendisliği',
        'Elektrik-Elektronik Mühendisliği',
        'Endüstri Mühendisliği',
        'Enerji Sistemleri Mühendisliği',
        'Havacılık ve Uzay Mühendisliği',
        'İnşaat Mühendisliği',
        'Kimya Mühendisliği',
        'Makine Mühendisliği',
        'Mekatronik Mühendisliği',
        'Metalurji ve Malzeme Mühendisliği',
        'Otomotiv Mühendisliği',
        'Yazılım Mühendisliği',
      ]
    },
    {
      'name': 'Sağlık Bilimleri Fakültesi',
      'icon': Icons.local_hospital,
      'departments': [
        'Beslenme ve Diyetetik',
        'Çocuk Gelişimi',
        'Fizyoterapi ve Rehabilitasyon',
        'Hemşirelik',
        'Odyoloji',
      ]
    },
    {
      'name': 'Sivil Havacılık Yüksekokulu',
      'icon': Icons.flight,
      'departments': [
        'Havacılık Yönetimi',
        'Pilotaj',
        'Uçak Elektrik ve Elektroniği',
        'Uçak Gövde ve Motor Bakımı',
      ]
    },
    {
      'name': 'İşletme Fakültesi',
      'icon': Icons.business,
      'departments': [
        'Halkla İlişkiler ve Reklamcılık',
        'İktisat',
        'İşletme',
        'Maliye',
        'Siyaset Bilimi ve Kamu Yönetimi',
        'Turizm İşletmeciliği',
        'Uluslararası Ticaret ve Lojistik',
        'Uluslararası İlişkiler',
      ]
    },
    {
      'name': 'Güzel Sanatlar Tasarım ve Mimarlık Fakültesi',
      'icon': Icons.architecture,
      'departments': [
        'Grafik Tasarım',
        'Endüstriyel Tasarım',
        'İç Mimarlık ve Çevre Tasarımı',
        'Mimarlık',
        'Tekstil ve Moda Tasarımı',
      ]
    },
    {
      'name': 'Hukuk Fakültesi',
      'icon': Icons.gavel,
      'departments': [
        'Hukuk',
      ]
    },
    {
      'name': 'Fen-Edebiyat Fakültesi',
      'icon': Icons.book,
      'departments': [
        'İngiliz Dili ve Edebiyatı',
        'İngilizce Mütercim ve Tercümanlık',
        'Matematik',
        'Psikoloji',
      ]
    },
    {
      'name': 'Tıp Fakültesi',
      'icon': Icons.medical_services,
      'departments': [
        'Tıp',
      ]
    },
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
    _scrollController.dispose();
    super.dispose();
  }

  void navigateToDepartmentSelection() {
    if (selectedFacultyIndex == -1) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentSelectionScreen(
          faculty: faculties[selectedFacultyIndex]['name'],
          departments: faculties[selectedFacultyIndex]['departments'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "FAKÜLTE SEÇİN",
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
                          "Hangi fakültede okuyorsunuz?",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Bölümünüzü seçmek için önce fakültenizi seçin",
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

                const SizedBox(height: 24),

                // Fakülte listesi
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: faculties.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedFacultyIndex == index;

                        return FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.05 * index, 0.05 * index + 0.5),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.05 * index, 0.05 * index + 0.5, curve: Curves.easeOutQuint),
                            )),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFacultyIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: isSelected ? 1 : 0,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Fakülte İkonu
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          faculties[index]['icon'],
                                          size: 30,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Fakülte İsmi
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            faculties[index]['name'],
                                            style: GoogleFonts.montserrat(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${faculties[index]['departments'].length} Bölüm",
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
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                        Icons.check,
                                        size: 16,
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
                      },
                    ),
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
                        onPressed: selectedFacultyIndex != -1 ? navigateToDepartmentSelection : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey.shade800,
                          disabledForegroundColor: Colors.grey.shade500,
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