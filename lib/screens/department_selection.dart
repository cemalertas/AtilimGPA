import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/gpa_type_selection.dart';
import 'package:gpatwo/services/lesson_fetcher.dart';
import 'package:gpatwo/data/department_data.dart';

class DepartmentSelectionScreen extends StatefulWidget {
  final String faculty;
  final List<dynamic> departments;

  const DepartmentSelectionScreen({
    Key? key,
    required this.faculty,
    required this.departments,
  }) : super(key: key);

  @override
  _DepartmentSelectionScreenState createState() =>
      _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  int selectedDepartmentIndex = -1;
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> departmentsList;
  final DataService _dataService = DataService();
  bool _isLoading = false;
  String? _errorMessage;

  final Map<String, IconData> departmentIcons = {
    'Bilgisayar Mühendisliği': Icons.computer_rounded,
    'Bilişim Sistemleri Mühendisliği': Icons.storage_rounded,
    'Elektrik-Elektronik Mühendisliği': Icons.electrical_services_rounded,
    'Endüstri Mühendisliği': Icons.precision_manufacturing_rounded,
    'Enerji Sistemleri Mühendisliği': Icons.flash_on_rounded,
    'Havacılık ve Uzay Mühendisliği': Icons.flight_rounded,
    'İmalat Mühendisliği': Icons.build_rounded,
    'İnşaat Mühendisliği': Icons.domain_rounded,
    'Kimya Mühendisliği': Icons.science_rounded,
    'Makine Mühendisliği': Icons.settings_rounded,
    'Mekatronik Mühendisliği': Icons.precision_manufacturing_rounded,
    'Metalurji ve Malzeme Mühendisliği': Icons.grain_rounded,
    'Otomotiv Mühendisliği': Icons.directions_car_rounded,
    'Yazılım Mühendisliği': Icons.code_rounded,
    'Fizik Grubu': Icons.blur_circular_rounded,
    'Beslenme ve Diyetetik': Icons.restaurant_menu,
    'Çocuk Gelişimi': Icons.child_care,
    'Fizyoterapi ve Rehabilitasyon': Icons.accessibility_new,
    'Hemşirelik': Icons.healing,
    'Odyoloji': Icons.hearing,
    'Havacılık Yönetimi': Icons.flight_takeoff,
    'Pilotaj': Icons.airplanemode_active,
    'Uçak Elektrik ve Elektroniği': Icons.electrical_services,
    'Uçak Gövde ve Motor Bakımı': Icons.build_circle,
    'İşletme': Icons.business_center,
    'İktisat': Icons.attach_money,
    'Halkla İlişkiler ve Reklamcılık': Icons.campaign,
    'Maliye': Icons.account_balance,
    'Siyaset Bilimi ve Kamu Yönetimi': Icons.gavel,
    'Turizm İşletmeciliği': Icons.beach_access,
    'Uluslararası Ticaret ve Lojistik': Icons.local_shipping,
    'Uluslararası İlişkiler': Icons.public,
    'Grafik Tasarım': Icons.brush,
    'Endüstriyel Tasarım': Icons.design_services,
    'İç Mimarlık ve Çevre Tasarımı': Icons.weekend,
    'Mimarlık': Icons.architecture,
    'Tekstil ve Moda Tasarımı': Icons.palette,
    'Hukuk': Icons.gavel,
    'İngiliz Dili ve Edebiyatı': Icons.menu_book,
    'İngilizce Mütercim ve Tercümanlık': Icons.translate,
    'Matematik': Icons.functions,
    'Psikoloji': Icons.psychology,
    'Tıp': Icons.local_hospital,
    'Default': Icons.school_rounded,
  };

  @override
  void initState() {
    super.initState();
    // Bölümleri uygun formata dönüştür ve bölüm kodlarını ekle
    departmentsList = widget.departments.map((dept) {
      return {
        'name': dept,
        'icon': departmentIcons[dept] ?? departmentIcons['Default'],
        'code': _getDepartmentCode(dept),
      };
    }).toList();
  }

  // Bölüm adından bölüm kodunu bul
  String? _getDepartmentCode(String departmentName) {
    // Tüm fakültelerde ara
    final facultiesMap = DepartmentData.departmentsByFaculty;

    for (var faculty in facultiesMap.keys) {
      // Bu fakültedeki departman kodlarını ve isimlerini al
      final departmentsMap = facultiesMap[faculty]!;

      // Departman ismine göre kodunu bul
      for (var entry in departmentsMap.entries) {
        if (entry.value == departmentName) {
          return entry.key; // Bölüm kodunu döndür
        }
      }
    }

    print('⚠️ Bölüm kodu bulunamadı: $departmentName');
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Seçilen bölümün müfredatını getir
  Future<void> _fetchDepartmentCurriculum(String departmentName, String? departmentCode) async {
    if (departmentCode == null) {
      setState(() {
        _errorMessage = 'Bölüm kodu bulunamadı: $departmentName';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔍 Müfredat getiriliyor: $departmentName ($departmentCode)');
      final curriculum = await _dataService.fetchStructuredCurriculum(
        departmentCode: departmentCode,
      );

      print('✅ Müfredat başarıyla getirildi: $departmentName');
      print('📊 Dönem sayısı: ${curriculum.semesters.length}');
      print('📚 Toplam ders sayısı: ${curriculum.totalCourseCount}');

      // GPA hesaplama ekranına git ve müfredat verilerini aktar
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GPATypeSelectionScreen(
            department: departmentName,
            curriculum: curriculum,
          ),
        ),
      );
    } catch (e) {
      print('❌ Müfredat getirme hatası: $e');
      setState(() {
        _errorMessage = 'Müfredat bilgileri alınamadı. Lütfen tekrar deneyin.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToGPA() {
    if (selectedDepartmentIndex == -1) return;

    final selectedDepartment = departmentsList[selectedDepartmentIndex]['name'];
    final selectedDepartmentCode = departmentsList[selectedDepartmentIndex]['code'];
    _fetchDepartmentCurriculum(selectedDepartment, selectedDepartmentCode);
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
          "BÖLÜM SEÇİN",
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
                // Fakülte bilgisi
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
                        "FAKÜLTE",
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.faculty,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bölümünüzü seçin",
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "GPA hesaplaması için bölümünüzü seçin",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Hata mesajı (varsa)
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Bölüm listesi
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: departmentsList.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedDepartmentIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDepartmentIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [Color(0xFF262626), Color(0xFF0D0D0D)]
                                    : [Colors.white, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  spreadRadius: isSelected ? 1 : 0,
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
                                // Bölüm İkonu
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.15)
                                        : Colors.grey.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      departmentsList[index]['icon'],
                                      size: 28,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Bölüm İsmi
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        departmentsList[index]['name'],
                                        style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      if (departmentsList[index]['code'] != null)
                                        const SizedBox(height: 4),
                                      if (departmentsList[index]['code'] != null)
                                        Text(
                                          "Kod: ${departmentsList[index]['code']}",
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.black54,
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
                                    size: 16,
                                    color: Colors.black,
                                  )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Devam butonu
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading || selectedDepartmentIndex == -1
                        ? null
                        : navigateToGPA,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}